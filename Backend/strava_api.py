from config import STRAVA_AUTH_URL, STRAVA_ACTIVITIES_URL, STRAVA_DATA
import requests

class StravaApi:
    def __init__(self):
        self.dataset = None
        self.request_new_token_and_set_dataset()

    def request_new_token_and_set_dataset(self):
        response = requests.post(STRAVA_AUTH_URL, data=STRAVA_DATA, verify=False)
        access_token = response.json()['access_token']

        header = {'Authorization': 'Bearer ' + access_token}
        my_dataset = requests.get(STRAVA_ACTIVITIES_URL, headers=header).json()
    
    def get_average_speed_for_type_activity(self, type_activity): # in km/h
        activities = self.dataset.loc[self.dataset['type'] == type_activity]
        average_speed = round((activities['average_speed'].mean() * 18) / 5, 2) # coverting from m/s to km/h

        return average_speed

    
    