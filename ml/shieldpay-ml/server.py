from flask import Flask, request, jsonify
import joblib
import pandas as pd

app = Flask(__name__)

# MODELİ YÜKLE
model = joblib.load("fraud_pipeline.joblib")

@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"})

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()

    # Eğitimde kullanılan kolonlar
    cols = model.feature_names_in_

    # Boş dataframe
    df = pd.DataFrame(columns=cols)
    df.loc[0] = 0

    # Gelen değerleri yerleştir
    for key, value in data.items():
        if key in df.columns:
            df.at[0, key] = value

    prediction = model.predict(df)[0]
    proba = model.predict_proba(df)[0][1]

    return jsonify({
        "fraud": bool(prediction),
        "probability": float(proba)
    })

if __name__ == "__main__":
    app.run(port=5000)
