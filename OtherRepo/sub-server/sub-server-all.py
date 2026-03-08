from flask import Flask, request, Response, jsonify
import subprocess
import time

app = Flask(__name__)

# ==========================================================
# TRANSLATE FUNCTION
# ==========================================================

def translate(text):

    result = subprocess.run(
        ["trans", "-b", "-s", "en", "-t", "id", text],
        capture_output=True,
        text=True
    )

    translated = result.stdout.strip()

    return translated


# ==========================================================
# BUILD VTT
# ==========================================================

def build_vtt(subs):

    output = ["WEBVTT\n"]

    total = len(subs)

    print("")
    print("====================================")
    print(f"TRANSLATE START  |  {total} lines")
    print("====================================")

    start_time = time.time()

    for i, line in enumerate(subs, start=1):

        text = line["text"]
        timecode = line["time"].replace(",", ".")

        print(f"[{i}/{total}] Translating:")
        print("TEXT:", text)

        translated = translate(text)

        print("RESULT:", translated)
        print("------------------------------------")

        output.append(str(i))
        output.append(timecode)
        output.append(translated)
        output.append("")

    end_time = time.time()

    print("====================================")
    print("TRANSLATE FINISHED")
    print(f"Total lines : {total}")
    print(f"Time taken  : {round(end_time-start_time,2)} sec")
    print("====================================")
    print("")

    return "\n".join(output)


# ==========================================================
# API
# ==========================================================

@app.route("/translate_sub", methods=["POST"])
def translate_sub():

    data = request.json

    if not data or "subs" not in data:
        return jsonify({"error":"Invalid data"}),400

    subs = data["subs"]

    vtt = build_vtt(subs)

    return Response(
        vtt,
        mimetype="text/vtt"
    )


# ==========================================================
# MAIN
# ==========================================================

if __name__ == "__main__":

    print("")
    print("====================================")
    print(" MPV Subtitle Translate Server ")
    print("====================================")
    print("Listening on : http://0.0.0.0:5000")
    print("API endpoint : /translate_sub")
    print("====================================")
    print("")

    app.run(
        host="0.0.0.0",
        port=5000,
        debug=False
    )