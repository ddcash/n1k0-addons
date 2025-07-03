from flask import Flask, send_from_directory, render_template
import os
from collections import defaultdict

app = Flask(__name__)
RESOURCE_DIR = "/data/resources"

@app.route("/")
def index():
    categories = defaultdict(list)
    for root, dirs, filenames in os.walk(RESOURCE_DIR):
        rel_path = os.path.relpath(root, RESOURCE_DIR)
        if rel_path == ".":
            category = "Uncategorized"
        else:
            category = rel_path
        for f in filenames:
            categories[category].append(f)
    return render_template("index.html", categories=categories)

@app.route("/files/<path:filename>")
def serve_file(filename):
    return send_from_directory(RESOURCE_DIR, filename)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
