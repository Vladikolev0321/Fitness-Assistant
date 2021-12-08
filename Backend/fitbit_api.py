import fitbit, datetime
from config import FITBIT_ACCESS_TOKEN, FITBIT_CLIENT_ID, FITBIT_CLIENT_SECRET, FITBIT_REFRESH_TOKEN

class FitbitApi:
    def __init__(self):
        self.__auth_client = fitbit.Fitbit(FITBIT_CLIENT_ID, FITBIT_CLIENT_SECRET, oauth2=True,
                                        access_token=FITBIT_ACCESS_TOKEN,
                                        refresh_token=FITBIT_REFRESH_TOKEN)

    def get_steps_done_today(self):
        today = str(datetime.datetime.now().strftime("%Y-%m-%d"))
        activities = self.__auth_client.activities(date=today)
        return activities['summary']['steps']
    
    def get_calories_burned_today(self):
        today = str(datetime.datetime.now().strftime("%Y-%m-%d"))
        activities = self.__auth_client.activities(date=today)
        return activities['summary']['caloriesOut']
    