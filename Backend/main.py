from flask import Flask, request
from fitness_assistant import FitnessAssistant

app = Flask(__name__)
fitness_assistant = FitnessAssistant()


@app.route('/bot/steps', methods=["GET"])
def get_steps():
    return str(fitness_assistant.get_steps_done_today())



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
    app.run(debug=True)