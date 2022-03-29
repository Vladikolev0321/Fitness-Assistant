from datetime import date
from api.services.fitbit_api import FitbitApi
from api.services.strava_api import StravaApi
from apscheduler.schedulers.background import BackgroundScheduler
from models import CaloriesStepsData, FitnessTokens, Profiles, StravaActivities, WeightsData
from database import db
from api.routes import app

sched = BackgroundScheduler()

@sched.scheduled_job('cron', hour=23, minute=59)
def timed_job():
    with app.app_context():
        users = Profiles.query.all()
        for user in users:
            user_tokens = FitnessTokens.query.filter_by(user_id=user.id).first()
            fitbit_api = FitbitApi(user.username, user_tokens.fitbit_access_token, user_tokens.fitbit_refresh_token)
            strava_api = StravaApi(user_tokens.strava_refresh_token)

            if not CaloriesStepsData.query.filter_by(user_id=user.id).first():
                calories_steps_entry = CaloriesStepsData(user.id, date.today(), fitbit_api.get_steps_done_today(), fitbit_api.get_calories_burned_today())
                db.session.add(calories_steps_entry)
                db.session.commit()

            logged_weights = fitbit_api.get_latest_logged_weights()['weight']
            for weight in logged_weights:
                if not WeightsData.query.filter_by(date=weight['date']).first():
                    weight_entry = WeightsData(user.id, weight['date'], weight['weight'])
                    db.session.add(weight_entry)
            db.session.commit()

            for _, row in strava_api.dataset.iterrows():
                if not StravaActivities.query.filter_by(upload_id=row['upload_id']).first():
                    strava_entry = StravaActivities(user.id, row['upload_id'], row['type'], row['distance'],
                                            row['moving_time'], row['average_speed'], row['max_speed'], row['start_date'])
                    db.session.add(strava_entry)
            db.session.commit()

sched.start()