from functools import wraps
from flask import Flask, request, jsonify
import requests
from dummy_chat_controller import DummyChat
from fitness_assistant import FitnessAssistant
from flask_cors import CORS
import firebase_admin
import json
from firebase_admin import credentials, auth

app = Flask(__name__)
CORS(app)

credents = credentials.Certificate('fbadmin.json')
firebase = firebase_admin.initialize_app(credents)

fitness_assistant = FitnessAssistant()
dummyChat = DummyChat(fitness_assistant)

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
@app.route('/api/userinfo')
@check_token
def userinfo():
    return {'data': request.user['name']}, 200



@app.route('/', methods=["GET"])
def test():
    return "Hello"

@app.route('/bot/steps', methods=["GET"])
def get_steps():
    return str(fitness_assistant.get_steps_done_today())

@app.route('/bot/message', methods=["POST"])
def message_bot():
    #return "Hello"
    dummyChat = DummyChat(fitness_assistant)
    #print(request.get_json())
    message = request.get_json()['message']
    response = dummyChat.accept_message(message)
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
    app.run(debug=True, host="0.0.0.0")