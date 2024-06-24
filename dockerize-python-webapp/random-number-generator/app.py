from flask import Flask, jsonify # type: ignore
import random

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello people! Welcome to the Random Number Generator. Go to /random to get a random number between 1 and 100."

@app.route("/random")
def random_number():
    number = random.randint(1, 100)
    return jsonify({'random_number': number})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')