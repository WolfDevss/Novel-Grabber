import os
import subprocess
import uuid
from flask import Flask, request, send_file, jsonify

app = Flask(__name__)

@app.route("/make_epub", methods=["POST"])
def make_epub():
    data = request.get_json()
    if not data or "url" not in data:
        return jsonify({"error": "Missing 'url'"}), 400

    novel_url = data["url"]
    tmp_dir = f"/tmp/{uuid.uuid4()}"
    os.makedirs(tmp_dir, exist_ok=True)
    output_path = os.path.join(tmp_dir, "novel.epub")

    # Call NG-Launcher.jar instead of main.py
    cmd = [
        "java",
        "-jar",
        "NG-Launcher.jar",
        novel_url,
        "--output",
        output_path,
        "--settings", "settings.json"
    ]

    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        return jsonify({"error": "Failed to generate EPUB", "details": str(e)}), 500

    return send_file(output_path, as_attachment=True)
