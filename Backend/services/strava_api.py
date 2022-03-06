from config import STRAVA_AUTH_URL, STRAVA_ACTIVITIES_URL, STRAVA_CLIENT_ID, STRAVA_CLIENT_SECRET
import requests
import pandas as pd
from pandas import json_normalize



class StravaApi:
    def __init__(self, refresh_token):
        self.dataset = None
        self.request_new_token_and_set_dataset(refresh_token)

    def request_new_token_and_set_dataset(self, refresh_token):
        STRAVA_DATA = {
            'client_id': STRAVA_CLIENT_ID,
            'client_secret': STRAVA_CLIENT_SECRET,
            'refresh_token': refresh_token,
            'grant_type': "refresh_token",
            'f': 'json'
        }
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

    def get_distances_for_all_activities(self):
        rides = self.dataset.loc[self.dataset['type'] == 'Ride']
        runs = self.dataset.loc[self.dataset['type'] == 'Run']
        walks = self.dataset.loc[self.dataset['type'] == 'Walk']
        hikes = self.dataset.loc[self.dataset['type'] == 'Hike']
        
        ride_distance = int(rides['distance'].sum()/1000)
        run_distance = int(runs['distance'].sum()/1000)
        walk_distance = int(walks['distance'].sum()/1000)
        hikes_distance = int(hikes['distance'].sum()/1000)
        
        return {'ride_distance':ride_distance, 'run_distance':run_distance, 'walk_distance':walk_distance, 'hike_distance':hikes_distance}
    
    def get_percentage_distance_for_all_activities(self):
        distances = self.get_distances_for_all_activities()
        
        sum_distances = distances['ride_distance'] + distances['run_distance'] + distances['walk_distance'] + distances['hike_distance']

        return {'ride_distance_percentage':self.__percentage_from_whole(distances['ride_distance'], sum_distances),
         'run_distance_percentage':self.__percentage_from_whole(distances['run_distance'], sum_distances),
          'walk_distance_percentage':self.__percentage_from_whole(distances['walk_distance'], sum_distances),
           'hike_distance_percentage':self.__percentage_from_whole(distances['hike_distance'], sum_distances)}
    
    def get_activities_average_speed_list(self):
        rides = self.dataset.loc[self.dataset['type'] == 'Ride']
        runs = self.dataset.loc[self.dataset['type'] == 'Run']
        walks = self.dataset.loc[self.dataset['type'] == 'Walk']
        hikes = self.dataset.loc[self.dataset['type'] == 'Hike']

        rides_average = list(round((rides['average_speed'] * 18) / 5, 2))[::-1] # reversing the list
        runs_average = list(round((runs['average_speed'] * 18) / 5, 2))[::-1]
        walks_average = list(round((walks['average_speed'] * 18) / 5, 2))[::-1]
        hikes_average = list(round((hikes['average_speed'] * 18) / 5, 2))[::-1]

        return {'rides_average':rides_average,
                'runs_average':runs_average,
                'walks_average':walks_average,
                'hikes_average':hikes_average}


    def __percentage_from_whole(self, part, whole):
        percentage = 100 * float(part)/float(whole)
        return percentage 

    def __get_percent_change(self, current, previous):
        # add a check
        return (current - previous) / previous * 100.00


    
    