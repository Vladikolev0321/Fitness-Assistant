from flask import Flask, request
from fitness_assistant import FitnessAssistant

app = Flask(__name__)
fitness_assistant = FitnessAssistant()


@app.route('/bot', methods=["POST"])
def bot():
    try:
        query = request.get_json()["query"]
        result = None
        if query == "steps-today":
            result = fitness_assistant.get_steps_done_today()
        elif query == "calories-burned-today":
            result = fitness_assistant.get_calories_burned_today()
        elif query == "avg-speed":
            pass
        elif query == "get-distance-changed":
            pass
        return str(result)
    except:
        pass

if __name__ == '__main__':
    app.run(debug=True)