import joblib
import os

MODEL_PATH = os.path.join(os.path.dirname(__file__), "fraud_model.joblib")

model = joblib.load(MODEL_PATH)
print("Model yüklendi:", type(model))
