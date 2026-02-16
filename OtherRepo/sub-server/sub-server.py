# server_translate.py
from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route("/translate", methods=["POST"])
def translate():
    data = request.json
    text = data.get("text", "")

    if not text:
        return jsonify({"error": "No text"}), 400

    result = subprocess.run(
        ["trans", "-b", "-s", "en", "-t", "id", text],
        capture_output=True,
        text=True
    )

    translated = result.stdout.strip()

    return jsonify({
        "original": text,
        "translated": translated
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
