from database import db

class Profile(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)

    def __init__(self, name):
        self.name = name

class NotUnderstoodQuestion(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.String(80), nullable=False)

    def __init__(self, text):
        self.text = text

class UserData(db.Model):
    __table_args__ = (
        db.UniqueConstraint('user_id', 'date', name='unique_user_id_date'),
    )
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('profile.id'), nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    steps_count = db.Column(db.Integer, nullable=False)
    calories_out = db.Column(db.Integer, nullable=False)
    
    def __init__(self, user_id, date, steps_count, calories_out):
        self.user_id = user_id
        self.date = date
        self.steps_count = steps_count
        self.calories_out = calories_out


class FitnessTokens(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('profile.id'), unique=True, nullable=False)
    strava_refresh_token = db.Column(db.Text(), nullable=False)
    fitbit_access_token = db.Column(db.Text(), nullable=False)
    fitbit_refresh_token = db.Column(db.Text(), nullable=False)

    def __init__(self, user_id, strava_refresh_token, fitbit_access_token, fitbit_refresh_token):
        self.user_id = user_id
        self.strava_refresh_token = strava_refresh_token
        self.fitbit_access_token = fitbit_access_token
        self.fitbit_refresh_token = fitbit_refresh_token

