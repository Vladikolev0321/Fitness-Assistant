import json
import requests
from config import BOT_URL
class BotApi:
    def process_message(self, message):
        response = requests.post(BOT_URL, data=json.dumps({"text": message}))
        return response.json()