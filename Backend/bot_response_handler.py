import random


class BotResponseHandler:
    def process_bot_response(self, data, fitbit_api, strava_api):
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
                        return f"For walking activity your average speed is {strava_api.get_average_speed_for_type_activity('Walk')} km/h"
                    if entity in ["hike", "hiking"]:
                        return f"For hiking activity your average speed is {strava_api.get_average_speed_for_type_activity('Hike')} km/h"
                    if entity in ["run", "running"]:
                        return f"For running activity your average speed is {strava_api.get_average_speed_for_type_activity('Run')} km/h"
                    if entity in ["cycle", "cycling"]:
                        return f"For cycling activity your average speed is {strava_api.get_average_speed_for_type_activity('Ride')} km/h"
                    return "Invalid activity"
                return "Average speed for what type of activity?"
            if predicted_intent == "steps_done":
                if len(data['entities']) == 1:
                    entity = data['entities'][0]['value'].lower()
                    if entity in ["today"]:
                        return f"Today you have done {fitbit_api.get_steps_done_today()} steps"
                    return  "Invalid time range"
                return "You are not specifying time range"
            if predicted_intent == "calories_burned":
                if len(data['entities']) == 1:
                    entity = data['entities'][0]['value'].lower()
                    if entity in ["today"]:
                        return f"Today you have burnt {fitbit_api.get_calories_burned_today()} calories"
                    return  "Invalid time range"
                return "You are not specifying time range"
            if predicted_intent == "logged_weight":
                return f"Last time you logged your weight you was {fitbit_api.get_last_logged_weight()} kg"
            if predicted_intent == "distance_activity":
                return "You can check this info in the dashboard"
            if predicted_intent == "bot_purpose":
                return "My purpose is to give you information about your activity"
            if predicted_intent == "get_bmr":
                return f"Your bmr is {fitbit_api.get_bmr()}"
            if predicted_intent == "calories_needed":
                if len(data['entities']) == 1:
                    entity = data['entities'][0]['value'].lower()
                    if entity == "gain":
                        pass
                    if entity == "loose":
                        pass
                    return "You are not specifying if you want to loose or gain weight"
                return "You are not specifying if you want to loose or gain weight"
            if predicted_intent == "change_in_performance":
                if len(data['entities']) == 1:
                    entity = data['entities'][0]['value'].lower()
                    if entity in ["walk", "walking"]:
                        return strava_api.get_distance_made_change_in_percents("Walk")
                    if entity in ["hike", "hiking"]:
                        return strava_api.get_distance_made_change_in_percents("Hike")
                    if entity in ["run", "running"]:
                        return strava_api.get_distance_made_change_in_percents("Run")
                    if entity in ["cycle", "cycling"]:
                        return strava_api.get_distance_made_change_in_percents("Ride")
                    return "Invalid activity"
                return "You are not specifying for what type of activity you want information"
        else:
            return "I didn't get that, try again."