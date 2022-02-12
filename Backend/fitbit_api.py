import fitbit, datetime
#from config import FITBIT_ACCESS_TOKEN, FITBIT_CLIENT_ID, FITBIT_CLIENT_SECRET, FITBIT_REFRESH_TOKEN
from config import FITBIT_CLIENT_ID, FITBIT_CLIENT_SECRET
class FitbitApi:
    def __init__(self, access_token, refresh_token):
        self.__auth_client = fitbit.Fitbit(FITBIT_CLIENT_ID, FITBIT_CLIENT_SECRET, oauth2=True,
                                        access_token=access_token,
                                        refresh_token=refresh_token)

    def get_steps_done_today(self):
        today = str(datetime.datetime.now().strftime("%Y-%m-%d"))
        activities = self.__auth_client.activities(date=today)
        return activities['summary']['steps']
    
    def get_calories_burned_today(self):
        today = str(datetime.datetime.now().strftime("%Y-%m-%d"))
        activities = self.__auth_client.activities(date=today)
        return activities['summary']['caloriesOut']
    
    def get_last_logged_weight(self):
        weight = self.__auth_client.get_bodyweight(period="1m")
        weight = weight['weight'][-1]['weight'] * 0.453592 # transfer from lbs to kg
        return weight