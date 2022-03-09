import fitbit, datetime
#from config import FITBIT_ACCESS_TOKEN, FITBIT_CLIENT_ID, FITBIT_CLIENT_SECRET, FITBIT_REFRESH_TOKEN
from config import FITBIT_CLIENT_ID, FITBIT_CLIENT_SECRET
from models import FitnessTokens, Profile
from database import db

class FitbitApi:
    def __init__(self, user_name, access_token, refresh_token):
        refresh_cb = self.refresh_token(user_name)
        self.__auth_client = fitbit.Fitbit(FITBIT_CLIENT_ID, FITBIT_CLIENT_SECRET, oauth2=True,
                                        access_token=access_token,
                                        refresh_token=refresh_token, refresh_cb=refresh_cb)
    
    def refresh_token(self, user_name):
        profile = Profile.query.filter_by(name=user_name).first()
        user_tokens = FitnessTokens.query.filter_by(user_id=profile.id).first()
        def save_fitbit_tokens(token):
                print('refreshing tokens')
                user_tokens.fitbit_access_token = token['access_token']
                user_tokens.fitbit_refresh_token = token['refresh_token']
                db.session.commit()
        return save_fitbit_tokens

                    
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
    
    # https://www.omnicalculator.com/health/bmr
    def get_bmr(self):
        weight_in_lbs = self.__auth_client.user_profile_get()['user']['weight']
        age = self.__auth_client.user_profile_get()['user']['age']
        gender = self.__auth_client.user_profile_get()['user']['gender']
        height_in_inches = self.__auth_client.user_profile_get()['user']['height']

        weight_kg = weight_in_lbs / 2.2
        heigh_cm = height_in_inches * 2.54
        bmr = None
        if gender == "MALE":
            bmr = int((10 * weight_kg) + (6.25 * heigh_cm) - (5 * age) + 5)
        elif gender == "FEMALE":
            bmr = int((10 * weight_kg) + (6.25 * heigh_cm) - (5 * age) - 161)
        return bmr
    
    def get_latest_seven_days_steps(self):
        curr_date = datetime.datetime.now().strftime("%Y-%m-%d")
        before_7_days_date = (datetime.datetime.now() - datetime.timedelta(days=7)).strftime("%Y-%m-%d")
        steps = self.__auth_client.time_series("activities/steps", base_date=before_7_days_date, end_date=curr_date)["activities-steps"]
        return steps

    def get_latest_seven_days_calories(self):
        curr_date = datetime.datetime.now().strftime("%Y-%m-%d")
        before_7_days_date = (datetime.datetime.now() - datetime.timedelta(days=7)).strftime("%Y-%m-%d")
        calories = self.__auth_client.time_series("activities/calories", base_date=before_7_days_date, end_date=curr_date)["activities-calories"]
        return calories
    