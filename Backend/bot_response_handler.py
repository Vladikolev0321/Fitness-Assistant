import random


class BotResponseHandler:
    def process_bot_response(self, data):
        prediction_confidence = data['intent']['confidence']
        if prediction_confidence > 0.75:
            predicted_intent = data['intent']['name']
            if predicted_intent == "greet":
                return random.choice(["Hi", "Hey", "Hello", "Good day", "Whats up"])
            if predicted_intent == "goodbye":
                return random.choice(["cya", "See you later", "Goodbye", "Have a Good day"])
            if predicted_intent == "exercising_benefit":
                return "Improved cardiovascular health.\nLowers risk of heart disease, stroke, \
                 and diabetes.\nHelps manage weight. \nReduced blood pressure. \nEnhanced aerobic fitness.\
                  \nImproved muscular strength and endurance. \nImproved joint flexibility and range of motion. \nStress relief."
            if predicted_intent == "get_average_speed":
                if len(data['entities']) == 1:#
                    entity = data['entities'][0]['value'].lower()
                    if entity in ["walk", "walking"]:
                        pass
                    if entity in ["hike", "hiking"]:
                        pass
                    if entity in ["run", "runing"]:
                        pass
                    if entity in ["cycle", "cycling"]:
                        pass
                    # else
                    # Can't understand - Average speed for what type of activity
                pass # Can't understand
            if predicted_intent == "steps_done":
                if len(data['entities']) == 1:
                    entity = data['entities'][0]['value'].lower()
                    if entity in ["today"]:
                        pass
                    # Can't understand - You are not specifying the time range
                pass
            if predicted_intent == "calories_burned":
                if len(data['entities']) == 1:
                    entity = data['entities'][0]['value'].lower()
                    if entity in ["today"]:
                        pass
                    # Can't understand - You are not specifying the time range
                pass
            if predicted_intent == "logged_weight":
                # return last logged weight
                pass
            if predicted_intent == "distance_activity":
                # This info is contained in the dashboard
                pass
            if predicted_intent == "bot_purpose":
                # My purpose is to inform you about your activity
                pass
            if predicted_intent == "calories_needed":
                if len(data['entities']) == 1:
                    entity = data['entities'][0]['value'].lower()
                    if entity == "gain":
                        pass
                    if entity == "loose":
                        pass
                    # Can't understand - You are not specifying if you want to loose or gain weight
                pass
            if predicted_intent == "change_in_performance":
                if len(data['entities']) == 1:
                    entity = data['entities'][0]['value'].lower()
                    if entity in ["walk", "walking"]:
                        pass
                    if entity in ["hike", "hiking"]:
                        pass
                    if entity in ["run", "runing"]:
                        pass
                    if entity in ["cycle", "cycling"]:
                        pass
                    # Can't understand - You are not specifying for what type of activitty you want information
                    
                pass