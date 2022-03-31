from dis import dis
from tracemalloc import start
from database import db

class Profiles(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(80), unique=True, nullable=False)

    def __init__(self, name, email):
        self.username = name
        self.email = email

class NotUnderstoodQuestions(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    question = db.Column(db.String(80), nullable=False)

    def __init__(self, text):
        self.question = text

class CaloriesStepsData(db.Model):
    __table_args__ = (
        db.UniqueConstraint('user_id', 'date', name='unique_user_id_date'),
    )
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('profiles.id'), nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    steps_count = db.Column(db.Integer, nullable=False)
    calories_out = db.Column(db.Integer, nullable=False)
    
    def __init__(self, user_id, date, steps_count, calories_out):
        self.user_id = user_id
        self.date = date
        self.steps_count = steps_count
        self.calories_out = calories_out

class StravaActivities(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('profiles.id'), nullable=False)
    upload_id = db.Column(db.BigInteger, unique=True, nullable=False)
    type = db.Column(db.String(80), nullable=False)
    distance = db.Column(db.Integer, nullable=False)
    moving_time = db.Column(db.Integer, nullable=False)
    average_speed = db.Column(db.Float, nullable=False)
    max_speed = db.Column(db.Float, nullable=False)
    date = db.Column(db.DateTime, nullable=False)

    def __init__(self, user_id, upload_id, type, distance, moving_time, average_speed, max_speed, start_date):
        self.user_id = user_id
        self.upload_id = upload_id
        self.type = type
        self.distance = distance
        self.moving_time = moving_time
        self.average_speed = average_speed
        self.max_speed = max_speed
        self.date = start_date

class WeightsData(db.Model):
    id = id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('profiles.id'), nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    weight = db.Column(db.Float, nullable=False)

    def __init__(self, user_id, date, weight):
        self.user_id = user_id
        self.date = date
        self.weight = weight



class FitnessTokens(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('profiles.id'), unique=True, nullable=False)
    strava_refresh_token = db.Column(db.Text(), nullable=False)
    fitbit_access_token = db.Column(db.Text(), nullable=False)
    fitbit_refresh_token = db.Column(db.Text(), nullable=False)

    def __init__(self, user_id, strava_refresh_token, fitbit_access_token, fitbit_refresh_token):
        self.user_id = user_id
        self.strava_refresh_token = strava_refresh_token
        self.fitbit_access_token = fitbit_access_token
        self.fitbit_refresh_token = fitbit_refresh_token

