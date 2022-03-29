from functools import wraps
import firebase_admin
from firebase_admin import credentials, auth
from flask import request

credents = credentials.Certificate('fbadmin.json')
firebase = firebase_admin.initialize_app(credents)

def check_token(f):
    @wraps(f)
    def wrap(*args,**kwargs):
        if not request.headers.get('authorization'):
            return {'message': 'No token provided'}, 400
        try:
            user = auth.verify_id_token(request.headers['authorization'])
            request.user = user
        except:
            return {'message':'Invalid token provided.'}, 400
        return f(*args, **kwargs)
    return wrap