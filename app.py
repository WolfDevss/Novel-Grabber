from flask import Flask, request, send_file, jsonify
import subprocess
import os
import uuid

app = Flask(__name__)

@app.route("/make_epub", methods=["POST"])
def make_epub():
    data = request.json
    url = data.get("url")

    if not url:
        return jsonify({"error": "Missing url"}), 400

    job_id = str(uuid.uuid4())
    output_dir = f"/tmp/{job_id}"
    os.makedirs(output_dir, exist_ok=True)

    output_file = f"{output_dir}/novel.epub"

    # Call Novel-Grabber CLI
    cmd = [
        "python",
        "main.py",
        url,
        "--output",
        output_file
    ]

    subprocess.run(cmd, check=True)

    return send_file(output_file, as_attachment=True)
