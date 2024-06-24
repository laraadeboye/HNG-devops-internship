
# How to Dockerise a python web application

Our web application, `random-number-generator`,  is a python web application, that returns a random number between 1 and 100. It is based on the flask framework.

Steps
We will use a [virtual environment](https://flask.palletsprojects.com/en/3.0.x/installation/#python-version) to manage dependencies for our project and test whether our app is working before creating a docker file.

1. Create a virtual environment in Linux by running the following commands:

#
    mkdir random-number-generator
    cd random-number-generator
    python3 -m venv .venv


2. Create a `requirements.txt`, `app.py` , `Dockerfile` and `.dockerignore` files. The `requirements.txt` file will list  the dependencies rquired for the project (which in this case is flask). The `app.py` is the main python file that contains the application code, `.dockerignore` will be used to specify files and directories to exclude from being copied into our container.

#
    touch requirements.txt
    touch app.py
    touch Dockerfile
    touch .dockerignore
    
You can also include a `README.md` file to provide a brief overview of the project including how to set it up and run it.

3. Write the following in the `requirements.txt` file:

#
    Flask 3.0.3

4. Write the following in the `app.py` file:

```
from flask import Flask, jsonify
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


```
### To test the app in a virtual environment:

1. Activate the virtual environment:

#
    source venv/bin/activate

 or
#
    . .venv/bin/activate

2. Install the dependencies:
#
    pip install -r requirements.txt

3. Run the application within the environment
#
    python3 app.py

4. The app will run in adebugging mode on the terminal and can be viewed on our web browser by pasting the following:

#
    http://[IP]:5000/

5. Type `deactivate` in the terminal to exit the environment.


### To run the app in a docker container:

1. Paste the following in the dockerfile:

```
# Use the official Python image from the Docker Hub
FROM python:3.10.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt requirements.txt

# Install the dependencies
RUN pip install -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Expose the port that the app runs on
EXPOSE 5000

# Define the command to run the application
CMD ["python", "app.py"]
```

2. Build the docker image:

#
    docker build -t random-number-generator .

3. Run the docker container in detached mode, naming it `random-number-app`:
#
    docker run --name random-number-app -d -p 5000:5000 random-number-generator

4. The app can be viewed in our browser on:
#
    http://0.0.0.0:5000


### Explanation of the python code
The Python code uses the Flask framework to create a simple web application. It imports `Flask` to set up the app, `jsonify` to convert Python dictionaries into JSON responses, and the `random` module to generate random numbers. The application is instantiated with `app = Flask(__name__)`. It defines two routes: the root (`/`) that returns a welcome message, and `/random` that returns a random number between 1 and 100 in JSON format. The app runs with `app.run(debug=True)` within the `if __name__ == '__main__':` block, ensuring the script runs directly and debug mode is enabled for detailed error pages and automatic server reloading on code changes.