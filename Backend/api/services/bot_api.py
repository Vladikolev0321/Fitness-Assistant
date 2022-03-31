import json
import os
import requests
class BotApi:
    def get_response(self, message):
        response = requests.post(os.environ.get('BOT_URL'), data=json.dumps({"text": message}))
        return response.json()