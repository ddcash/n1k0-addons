from flask import Flask, send_from_directory, render_template
import os

app = Flask(__name__)
RESOURCE_DIR = "/data/resources"

@app.route("/")
def index():
    files = []
    for root, dirs, filenames in os.walk(RESOURCE_DIR):
        for f in filenames:
            path = os.path.relpath(os.path.join(root, f), RESOURCE_DIR)
            files.append(path)
    return render_template("index.html", files=files)

@app.route("/files/<path:filename>")
def serve_file(filename):
    return send_from_directory(RESOURCE_DIR, filename)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
