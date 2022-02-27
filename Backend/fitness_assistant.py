from services.fitbit_api import FitbitApi
from services.strava_api import StravaApi

class FitnessAssistant:
    def __init__(self):
        self.__strava_api = StravaApi()
        self.__fitbit_api = FitbitApi()

    def get_steps_done_today(self):
        return self.__fitbit_api.get_steps_done_today()

    def get_calories_burned_today(self):
        return self.__fitbit_api.get_calories_burned_today()

    def get_average_speed_for_type_activity(self, type_activity):
        return self.__strava_api.get_average_speed_for_type_activity(type_activity)

    def get_distance_made_change_in_percents_for_type_activity(self, type_activity):
        return self.__strava_api.get_distance_made_change_in_percents(type_activity)