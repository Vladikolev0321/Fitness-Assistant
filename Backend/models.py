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
