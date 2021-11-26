from flask import Flask

app = Flask(__name__)

@app.route('/bot')
def bot():
    return "Hello world"

if __name__ == '__main__':
    app.run()