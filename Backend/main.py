from cProfile import run
from datetime import date
from functools import wraps
from flask import Flask, request, jsonify
import requests
import database
from models import FitnessTokens, Profile, StravaActivities, UserData, Weight
from services.bot_api import BotApi
from dummy_chat_controller import DummyChat
from services.fitbit_api import FitbitApi
from fitness_assistant import FitnessAssistant
from flask_cors import CORS
import firebase_admin
import json
from firebase_admin import credentials, auth
from flask_sqlalchemy import SQLAlchemy
import sqlalchemy
#from dotenv import load_dotenv
from config import FITBIT_ACCESS_TOKEN, FITBIT_CLIENT_ID, FITBIT_CLIENT_SECRET, FITBIT_REFRESH_TOKEN, SQLALCHEMY_DATABASE_URI
from services.strava_api import StravaApi
from database import db
from bot_response_handler import BotResponseHandler
bot_response_handler = BotResponseHandler()


app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = SQLALCHEMY_DATABASE_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

#db = SQLAlchemy(app)
database.init_app(app)
bot_api = BotApi()

credents = credentials.Certificate('fbadmin.json')
firebase = firebase_admin.initialize_app(credents)

#fitness_assistant = FitnessAssistant()
#dummyChat = DummyChat(fitness_assistant)
from apscheduler.schedulers.background import BackgroundScheduler

sched = BackgroundScheduler()

@sched.scheduled_job('cron', hour=23, minute=59)
def timed_job():
    with app.app_context():
        print("here")
        users = Profile.query.all()

        for user in users:
            user_tokens = FitnessTokens.query.filter_by(user_id=user.id).first()
    
            fitbit_api = FitbitApi(user.name, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)

            calories_steps_entry = UserData(user.id, date.today(), fitbit_api.get_steps_done_today(), fitbit_api.get_calories_burned_today())
            db.session.add(calories_steps_entry)
            db.session.commit()

            logged_weights = fitbit_api.get_latest_logged_weights()['weight']
            for weight in logged_weights:
                if not Weight.query.filter_by(date=weight['date']).first():
                    weight_entry = Weight(user.id, weight['date'], weight['weight'])
                    db.session.add(weight_entry)
            db.session.commit()

            for _, row in strava_api.dataset.iterrows():
                if not StravaActivities.query.filter_by(upload_id=row['upload_id']).first():
                    print("in")
                    strava_entry = StravaActivities(user.id, row['upload_id'], row['type'], row['distance'],
                                            row['moving_time'], row['average_speed'], row['max_speed'], row['start_date'])
                    db.session.add(strava_entry)
            db.session.commit()
            

            print("finished")
                

sched.start()
    
def check_token(f):
    @wraps(f)
    def wrap(*args,**kwargs):
        if not request.headers.get('authorization'):
            return {'message': 'No token provided'}, 400
        try:
            user = auth.verify_id_token(request.headers['authorization'])
            request.user = user
        except:
            return {'message':'Invalid token provided.'},400
        return f(*args, **kwargs)
    return wrap

@app.route('/dashboard', methods=["GET"])
@check_token
def get_dashboard_info():
    curr_user = Profile.query.filter_by(name=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            fitbit_api = FitbitApi(curr_user.name, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)
            steps_today = fitbit_api.get_steps_done_today()
            burnt_calories = fitbit_api.get_calories_burned_today()
            weight = fitbit_api.get_last_logged_weight()

            strava_activities = StravaActivities.query.filter_by(user_id=curr_user.id).all()
            rides = [act for act in strava_activities if act.type == 'Ride']
            runs = [act for act in strava_activities if act.type == 'Run']
            walks = [act for act in strava_activities if act.type == 'Walk']
            hikes = [act for act in strava_activities if act.type == 'Hike']
            
            ride_distance = int(sum(act.distance for act in rides)/1000)
            run_distance = int(sum(act.distance for act in runs)/1000)
            walk_distance = int(sum(act.distance for act in walks)/1000)
            hikes_distance = int(sum(act.distance for act in hikes)/1000)
            distances = {'ride_distance':ride_distance, 'run_distance':run_distance, 'walk_distance':walk_distance,
                         'hike_distance':hikes_distance}

            sum_distances = ride_distance + run_distance + walk_distance + hikes_distance
            percentages = {'ride_distance_percentage':percentage_from_whole(ride_distance, sum_distances),
                            'run_distance_percentage':percentage_from_whole(run_distance, sum_distances),
                            'walk_distance_percentage':percentage_from_whole(walk_distance, sum_distances),
                            'hike_distance_percentage':percentage_from_whole(hikes_distance, sum_distances)}

            return jsonify({"steps":str(steps_today), "burnt_calories":str(burnt_calories),
                    "distances":distances, "percentages":percentages, "weight":weight})
        
def percentage_from_whole(part, whole):
        percentage = 100 * float(part)/float(whole)
        return percentage

@app.route('/dashboard/steps_chart', methods=["GET"])
@check_token
def get_steps_chart_info():
    curr_user = Profile.query.filter_by(name=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            fitbit_api = FitbitApi(curr_user.name, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)

            user_data = UserData.query.filter_by(user_id=curr_user.id).order_by(UserData.date)[-7:]
            steps = []
            for data in user_data:
                steps.append({'dateTime':data.date.strftime("%Y-%m-%d"), 'value':str(data.steps_count)})

            return jsonify({"steps":steps})

@app.route('/dashboard/activities_average', methods=["GET"])
@check_token
def get_activities_averages_chart_info():
    curr_user = Profile.query.filter_by(name=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            fitbit_api = FitbitApi(curr_user.name, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)

            strava_activities = StravaActivities.query.filter_by(user_id=curr_user.id).order_by(StravaActivities.start_date).all()
            rides = [act for act in strava_activities if act.type == 'Ride']
            runs = [act for act in strava_activities if act.type == 'Run']
            walks = [act for act in strava_activities if act.type == 'Walk']
            hikes = [act for act in strava_activities if act.type == 'Hike']

            rides_average = [round((act.average_speed * 18) / 5, 2) for act in rides][-10:]
            runs_average = [round((act.average_speed * 18) / 5, 2) for act in runs][-10:]
            walks_average = [round((act.average_speed * 18) / 5, 2) for act in walks][-10:]
            hikes_average = [round((act.average_speed * 18) / 5, 2) for act in hikes][-10:]

            average_speed =  {'rides_average':rides_average,
                            'runs_average':runs_average,
                            'walks_average':walks_average,
                            'hikes_average':hikes_average}

            return jsonify({"average_speed_list":average_speed})

@app.route('/dashboard/calories_info', methods=["GET"])
@check_token
def get_calories_burned_info():
    curr_user = Profile.query.filter_by(name=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            fitbit_api = FitbitApi(curr_user.name, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)

            user_data = UserData.query.filter_by(user_id=curr_user.id).order_by(UserData.date)[-7:]
            calories_burned = []
            for data in user_data:
                calories_burned.append({'dateTime':data.date.strftime("%Y-%m-%d"), 'value':str(data.calories_out)})

            return jsonify({"calories_burned_list":calories_burned})

@app.route('/dashboard/weight_info', methods=["GET"])
@check_token
def get_logged_weight_info():
    curr_user = Profile.query.filter_by(name=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            fitbit_api = FitbitApi(curr_user.name, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)

            weights = Weight.query.filter_by(user_id=curr_user.id).order_by(Weight.date)[-10:]
            weights = [weight_info.weight * 0.453592 for weight_info in weights]

            return jsonify({"weight_dates_info":weights})



# @app.route('/sign_in', methods=["POST"])
# @check_token
# def sign_in():
#     if not Profile.query.filter_by(name=request.user['name']).first():
#         entry = Profile(request.user['name'])
#         db.session.add(entry)
#         db.session.commit()
#         return jsonify({"message":f"User {request.user['name']} saved"})
#     return jsonify({"message":f"User {request.user['name']} already exists"})


@app.route('/save_tokens', methods=["POST"])
@check_token
def save_tokens():
    if not Profile.query.filter_by(name=request.user['name']).first():
        entry = Profile(request.user['name'])
        db.session.add(entry)
        db.session.commit()
        
        curr_user = Profile.query.filter_by(name=request.user['name']).first()

        if not FitnessTokens.query.filter_by(user_id=curr_user.id).first():
            data = request.headers
            tokens = FitnessTokens(curr_user.id, data['stravaRefreshToken'], data['fitbitAccessToken'], data['fitbitRefreshToken'])
            db.session.add(tokens)
            db.session.commit()

            user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        
            fitbit_api = FitbitApi(curr_user.name, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)

            steps_and_calories_last_30_days = fitbit_api.get_last_30_days_steps_and_calories()
            for index, day in enumerate(steps_and_calories_last_30_days['steps']):
                if steps_and_calories_last_30_days['steps'][index]['dateTime'] == steps_and_calories_last_30_days['calories'][index]['dateTime']:
                    calories_steps_entry = UserData(curr_user.id, steps_and_calories_last_30_days['steps'][index]['dateTime'],
                                                    steps_and_calories_last_30_days['steps'][index]['value'],
                                                    steps_and_calories_last_30_days['calories'][index]['value'])
                    db.session.add(calories_steps_entry)
            db.session.commit()

            logged_weights = fitbit_api.get_latest_logged_weights()['weight']
            for weight in logged_weights:
                if not Weight.query.filter_by(date=weight['date']).first():
                    weight_entry = Weight(curr_user.id, weight['date'], weight['weight'])
                    db.session.add(weight_entry)
            db.session.commit()

            for _, row in strava_api.dataset.iterrows():
                if not StravaActivities.query.filter_by(upload_id=row['upload_id']).first():
                    strava_entry = StravaActivities(curr_user.id, row['upload_id'], row['type'], row['distance'],
                                            row['moving_time'], row['average_speed'], row['max_speed'], row['start_date'])
                    db.session.add(strava_entry)
            db.session.commit()

            return jsonify({"message":f"User {request.user['name']} keys saved and information loaded"})
        else:
            return jsonify({"message":"User tokens are already stored"})
    return jsonify({"message":"You have not signed in"})



@app.route('/bot/steps', methods=["GET"])
def get_steps():
    return str(fitness_assistant.get_steps_done_today())

@app.route('/bot/message', methods=["POST"])
@check_token
def message_bot():
    curr_user = Profile.query.filter_by(name=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            fitbit_api = FitbitApi(curr_user.name, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)
            message = request.get_json()['message']
            response = bot_response_handler.process_bot_response(bot_api.get_response(message), fitbit_api, strava_api)
            return jsonify({"response":str(response)})


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, host="0.0.0.0")

