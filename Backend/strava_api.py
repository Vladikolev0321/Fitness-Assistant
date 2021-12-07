from config import STRAVA_AUTH_URL, STRAVA_ACTIVITIES_URL, STRAVA_DATA
import requests
import pandas as pd
from pandas import json_normalize


class StravaApi:
    def __init__(self):
        self.dataset = None
        self.request_new_token_and_set_dataset()

    def request_new_token_and_set_dataset(self):
        response = requests.post(STRAVA_AUTH_URL, data=STRAVA_DATA, verify=False)
        access_token = response.json()['access_token']

        header = {'Authorization': 'Bearer ' + access_token}
        data_as_json = requests.get(STRAVA_ACTIVITIES_URL, headers=header).json()
        self.dataset =  json_normalize(data_as_json)
    
    def get_average_speed_for_type_activity(self, type_activity): # in km/h
        activities = self.dataset.loc[self.dataset['type'] == type_activity]
        average_speed = round((activities['average_speed'].mean() * 18) / 5, 2) # coverting from m/s to km/h

        return average_speed

    def get_distance_made_change_in_percents(self, type_activity):
        info_for_activity = self.dataset.loc[self.dataset['type'] == type_activity]
        distances_for_activity = list(info_for_activity['distance'])
        percent_change = self.__get_percent_change(distances_for_activity[0], max(distances_for_activity))
        # add checks for returned percent change
        # if percent change == 0 => last activity distance is equal to the max
        # if percent is negative => last activity distance is lower <>% by the max
        # if percent is positive => last activity distance is more <>% by the max
        if percent_change == 0:
            return "Your last activity distance is equal to the max"
        elif percent_change < 0:
            return f"Your last activity distance is lower by {percent_change}% from the max"
        elif percent_change > 0:
            return f"Your last activity distance is more by {percent_change}% from the max"


    def __get_percent_change(current, previous):
        # add a check
        return (current - previous) / previous * 100.0


    
    