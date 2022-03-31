from cProfile import run
from datetime import date
from functools import wraps
import os
from statistics import mean
from api.services.fitness_data import calculate_strava_activities_distance, calculate_strava_activities_distance_percentages,  get_average_steps_for_last_7_days, get_calories_average_last_7_days, get_calories_last_7_days, get_logged_weight_average_last_10_times, get_logged_weight_last_10_times, get_steps_for_last_7_days, get_strava_activities_average_speed_of_last_7_times, get_strava_activities_average_speeds_last_7_times
from flask import Flask, request, jsonify
from grpc import services
import requests
import database
from models import FitnessTokens, Profiles, StravaActivities, CaloriesStepsData, WeightsData
from api.services.bot_api import BotApi
from api.services.fitbit_api import FitbitApi
from flask_cors import CORS
import firebase_admin
import json
from firebase_admin import credentials, auth
from flask_sqlalchemy import SQLAlchemy
import sqlalchemy
from api.services.strava_api import StravaApi
from database import db

from api.services.bot_response_handler import BotResponseHandler
bot_response_handler = BotResponseHandler()
from dotenv import load_dotenv

load_dotenv()
from decorators import check_token

app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('SQLALCHEMY_DATABASE_URI')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

database.init_app(app)
bot_api = BotApi()
import scheduler

@app.route('/dashboard', methods=["GET"])
@check_token
def get_dashboard_info():
    curr_user = Profiles.query.filter_by(username=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            fitbit_api = FitbitApi(curr_user.username, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            steps_today = fitbit_api.get_steps_done_today()
            burnt_calories = fitbit_api.get_calories_burned_today()
            weight = fitbit_api.get_last_logged_weight()
            distances = calculate_strava_activities_distance(curr_user)
            percentages = calculate_strava_activities_distance_percentages(curr_user)

            return jsonify({"steps":str(steps_today), "burnt_calories":str(burnt_calories),
                    "distances":distances, "percentages":percentages, "weight":weight})


@app.route('/dashboard/steps_info', methods=["GET"])
@check_token
def get_steps_info():
    curr_user = Profiles.query.filter_by(username=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            steps = get_steps_for_last_7_days(curr_user)
            steps_average = get_average_steps_for_last_7_days(curr_user)

            return jsonify({"steps":steps, "steps_average":steps_average})

@app.route('/dashboard/activities_average', methods=["GET"])
@check_token
def get_activities_averages_info():
    curr_user = Profiles.query.filter_by(username=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            average_speed_list = get_strava_activities_average_speeds_last_7_times(curr_user)
            average_speed = get_strava_activities_average_speed_of_last_7_times(curr_user)

            return jsonify({"average_speed_list":average_speed_list, "average_for_activity":average_speed})

@app.route('/dashboard/calories_info', methods=["GET"])
@check_token
def get_calories_burned_info():
    curr_user = Profiles.query.filter_by(username=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            calories_burned = get_calories_last_7_days(curr_user)
            calories_burned_average = get_calories_average_last_7_days(curr_user)

            return jsonify({"calories_burned_list":calories_burned, "calories_burned_average":calories_burned_average})

@app.route('/dashboard/weight_info', methods=["GET"])
@check_token
def get_logged_weight_info():
    curr_user = Profiles.query.filter_by(username=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            weights = get_logged_weight_last_10_times(curr_user)
            return jsonify({"weight_dates_info":weights, "weights_average":mean(weights)})

@app.route('/tokens', methods=["GET"])
@check_token
def check_if_user_has_tokens():
    curr_user = Profiles.query.filter_by(username=request.user['name']).first()
    if curr_user:
        if FitnessTokens.query.filter_by(user_id=curr_user.id).first():
            return jsonify({"are_tokens_stored":True})
        else:
            return jsonify({"are_tokens_stored":False})
    else:
        return jsonify({"are_tokens_stored":False})


@app.route('/tokens', methods=["POST"])
@check_token
def save_tokens():
    curr_user = Profiles.query.filter_by(username=request.user['name']).first()
    if not curr_user:
        print(request.user)
        entry = Profiles(request.user['name'], request.user['email'])
        db.session.add(entry)
        db.session.commit()
    
    curr_user = Profiles.query.filter_by(username=request.user['name']).first()

    if not FitnessTokens.query.filter_by(user_id=curr_user.id).first():
        data = request.headers
        tokens = FitnessTokens(curr_user.id, data['stravaRefreshToken'], data['fitbitAccessToken'], data['fitbitRefreshToken'])
        db.session.add(tokens)
        db.session.commit()

        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
    
        fitbit_api = FitbitApi(curr_user.username, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
        strava_api = StravaApi(user_tokens.strava_refresh_token)

        steps_and_calories_last_30_days = fitbit_api.get_last_30_days_steps_and_calories()
        for index, day in enumerate(steps_and_calories_last_30_days['steps']):
            if steps_and_calories_last_30_days['steps'][index]['dateTime'] == steps_and_calories_last_30_days['calories'][index]['dateTime']:
                calories_steps_entry = CaloriesStepsData(curr_user.id, steps_and_calories_last_30_days['steps'][index]['dateTime'],
                                                steps_and_calories_last_30_days['steps'][index]['value'],
                                                steps_and_calories_last_30_days['calories'][index]['value'])
                db.session.add(calories_steps_entry)
        db.session.commit()

        logged_weights = fitbit_api.get_latest_logged_weights()['weight']
        for weight in logged_weights:
            if not WeightsData.query.filter_by(date=weight['date']).first():
                weight_entry = WeightsData(curr_user.id, weight['date'], weight['weight'])
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
    

@app.route('/bot/message', methods=["POST"])
@check_token
def message_bot():
    curr_user = Profiles.query.filter_by(username=request.user['name']).first()
    if curr_user:
        user_tokens = FitnessTokens.query.filter_by(user_id=curr_user.id).first()
        if user_tokens:
            fitbit_api = FitbitApi(curr_user.username, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)
            message = request.get_json()['message']
            response = bot_response_handler.process_bot_response(bot_api.get_response(message), fitbit_api, strava_api)
            return jsonify({"response":str(response)})


