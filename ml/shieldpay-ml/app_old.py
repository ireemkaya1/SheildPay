from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"})

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    return jsonify({
        "fraud": False,
        "received": data
    })

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
