import os
from flask import Flask, request, render_template, send_file, abort

app = Flask(__name__)

@app.route('/')
def index():
    """
    Mostra una pagina con la lista degli utenti. Un utente è considerato
    tale se esiste un file PNG con il suo nome (es. `alice.png`).
    """
    users_folder = os.path.join(os.path.abspath(os.getcwd()), "users")
    users = []
    for file in os.listdir(users_folder):
        user_dir = os.path.join(users_folder, file)
        if os.path.isfile(user_dir) and file.lower().endswith('.png'):
            users.append(file[:-4])  # Remove .png extension

    return render_template('index.html', users=users)


@app.route('/profile')
def profile():
    """
    GET /profile?image=<image>
    If a local file named <image> exists,
    return that image. Otherwise return 404.
    """
    image = request.args.get('image')
    if not image:
        abort(400, description="image query parameter required")

    # Basic validation: disallow path separators
    #if '/' in image or '\\' in image:
    #    abort(400, description="invalid image file name")

    # Prevent path traversal: ensure profile_path is inside users_folder
    #try:
    #    if os.path.commonpath([users_folder, profile_image_path]) != users_folder:
    #        abort(400, description="invalid path")
    #except ValueError:
    #    abort(400, description="invalid path")

    users_folder = os.path.join(os.path.abspath(os.getcwd()), "users")
    profile_image_path = os.path.abspath(os.path.join(users_folder, image))

    if os.path.exists(profile_image_path) and os.path.isfile(profile_image_path):
        return send_file(profile_image_path, mimetype='image/png')

    abort(404, description="profile image not found")

if __name__ == '__main__':
    app.run(port=8080)