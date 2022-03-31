from functools import wraps
import os
import firebase_admin
from firebase_admin import credentials, auth
from flask import request
import ast

dict_information = ast.literal_eval(os.environ.get("FB_CONFIG"))
credents = credentials.Certificate(dict_information)
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