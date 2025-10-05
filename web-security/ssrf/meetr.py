from flask import Flask, request, render_template
from urllib.parse import urlparse
import http.client
import os
from flask import send_from_directory
import requests


class user:
    @staticmethod
    def updateProfileImage(data: bytes):

        """Write raw bytes to static/profile.png (overwrites existing file)."""
        static_dir = os.path.join(os.path.dirname(__file__), 'static')
        os.makedirs(static_dir, exist_ok=True)

        out_path = os.path.join(static_dir, 'profile.png')

        with open(out_path, 'wb') as f:
            f.write(data)


app = Flask(__name__)

@app.route('/pfp')
def pfp():
    
    url = request.args.get('url')

    response = requests.get(url)

    img_data = response.content

    user.updateProfileImage(img_data)
    
    return render_template('index.html')


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/profile.png')
def serve_profile():
    static_dir = os.path.join(os.path.dirname(__file__), 'static')
    return send_from_directory(static_dir, 'profile.png')


if __name__ == '__main__':
    app.run(port=8000)
