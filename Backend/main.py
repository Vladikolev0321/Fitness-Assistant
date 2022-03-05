from functools import wraps
from flask import Flask, request, jsonify
import requests
import database
from models import Profile
from services.bot_api import BotApi
from dummy_chat_controller import DummyChat
from services.fitbit_api import FitbitApi
from fitness_assistant import FitnessAssistant
from flask_cors import CORS
import firebase_admin
import json
from firebase_admin import credentials, auth
from flask_sqlalchemy import SQLAlchemy
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

def check_token(f):
    @wraps(f)
    def wrap(*args,**kwargs):
        if not request.headers.get('authorization'):
            return {'message': 'No token provided'},400
        try:
            user = auth.verify_id_token(request.headers['authorization'])
            request.user = user
        except:
            return {'message':'Invalid token provided.'},400
        return f(*args, **kwargs)
    return wrap

#Api route to test jwt
@app.route('/api/userinfo', methods=["POST"])
@check_token
def userinfo():
    request.data
    return {'data': request.user['name']}, 200

# test route
@app.route('/steps', methods=["GET"])
@check_token
def get_steps_try():
    #data = request.json
    data = request.headers
    fitbit_api = FitbitApi(data['fitbitAccessToken'], data['fitbitRefreshToken'])
    return str(fitbit_api.get_steps_done_today())

# test route
@app.route('/average_speed', methods=["GET"])
@check_token
def get_avg_speed():
    data = request.headers
    strava_api = StravaApi(data['stravaRefreshToken'])
    return str(strava_api.get_average_speed_for_type_activity("Walk"))

@app.route('/dashboard', methods=["GET"])
@check_token
def get_dashboard_info():
    data = request.headers
    fitbit_api = FitbitApi(data['fitbitAccessToken'], data['fitbitRefreshToken'])
    strava_api = StravaApi(data['stravaRefreshToken'])
    steps_today = fitbit_api.get_steps_done_today()
    burnt_calories = fitbit_api.get_calories_burned_today()
    weight = fitbit_api.get_last_logged_weight()
    distances = strava_api.get_distances_for_all_activities()
    percentages = strava_api.get_percentage_distance_for_all_activities()

    return jsonify({"steps":str(steps_today), "burnt_calories":str(burnt_calories),
            "distances":distances, "percentages":percentages, "weight":weight})

@app.route('/dashboard/steps_chart', methods=["GET"])
@check_token
def get_steps_chart_info():
    data = request.headers
    fitbit_api = FitbitApi(data['fitbitAccessToken'], data['fitbitRefreshToken'])
    strava_api = StravaApi(data['stravaRefreshToken'])

    steps = fitbit_api.get_latest_seven_days_steps()

    return jsonify({"steps":steps})

@app.route('/dashboard/activities_average', methods=["GET"])
@check_token
def get_activities_averages_chart_info():
    data = request.headers
    fitbit_api = FitbitApi(data['fitbitAccessToken'], data['fitbitRefreshToken'])
    strava_api = StravaApi(data['stravaRefreshToken'])

    average_speed = strava_api.get_activities_average_speed_list()

    return jsonify({"average_speed_list":average_speed})


@app.route('/register', methods=["POST"])
@check_token
def register():
    if not Profile.query.filter_by(name=request.user['name']):
        entry = Profile(request.user['name'])
        db.session.add(entry)
        db.session.commit()
        return f"User {request.user['name']} saved"
    return str(request.user['name'])



@app.route('/bot/steps', methods=["GET"])
def get_steps():
    return str(fitness_assistant.get_steps_done_today())

@app.route('/bot/message', methods=["POST"])
@check_token
def message_bot():
    data = request.headers
    fitbit_api = FitbitApi(data['fitbitAccessToken'], data['fitbitRefreshToken'])
    strava_api = StravaApi(data['stravaRefreshToken'])
    message = request.get_json()['message']
    response = bot_response_handler.process_bot_response(bot_api.get_response(message), fitbit_api, strava_api)
    return jsonify({"response":str(response)})

@app.route('/bot', methods=["POST"])
def bot():
    try:
        query = request.get_json()["query"]
        result = None
        if query == "steps-today":
            result = fitness_assistant.get_steps_done_today()
        elif query == "calories-burned-today":
            result = fitness_assistant.get_calories_burned_today()
        elif query == "avg-speed-ride":
            result = fitness_assistant.get_average_speed_for_type_activity("Ride")
        elif query == "get-distance-changed-ride":
           result = fitness_assistant.get_distance_made_change_in_percents_for_type_activity("Ride")
        return str(result)
    except:
        pass

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, host="0.0.0.0")

