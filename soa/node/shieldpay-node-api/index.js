/**
 * ShieldPay - Node API (REST Facade)
 * Endpoints:
 *  - GET  /health
 *  - GET  /api/rates?from=USD&to=TRY&amount=100   (Frankfurter hazır API)
 *  - POST /predict                               (REST -> SOAP Fraud servisi)
 */

require("dotenv").config();

const express = require("express");
const cors = require("cors");
const axios = require("axios");
const soap = require("soap"); // npm paketi: soap

const app = express();
app.use(cors());
app.use(express.json());

// --------------------
// Config
// --------------------
const PORT = process.env.PORT || 3001;

// Senin terminal çıktında böyle görünüyor:
// SOAP_WSDL_URL = http://127.0.0.1:8000/?wsdl
const SOAP_WSDL_URL = process.env.SOAP_WSDL_URL || "http://127.0.0.1:8000/?wsdl";

// --------------------
// SOAP Client (cache'li)
// --------------------
let soapClientPromise = null;

function getSoapClient() {
  if (!soapClientPromise) {
    soapClientPromise = soap.createClientAsync(SOAP_WSDL_URL);
  }
  return soapClientPromise;
}

// SOAP çağrısı: check_fraud(amount:int, risk_score:int) -> "FRAUD" | "CLEAN"
async function callFraudSoap(amount, riskScoreInt) {
  const client = await getSoapClient();

  // node-soap async metot adı genellikle <methodName>Async olur
  // Spyne servisinde method adı: check_fraud
  const args = {
    amount: Number(amount),
    risk_score: Number(riskScoreInt),
  };

  const responseArr = await client.check_fraudAsync(args);

  // node-soap dönüşü: [result, raw, header, request]
  const result = responseArr && responseArr[0] ? responseArr[0] : null;

  // Spyne / node-soap bazen sonucu check_fraudResult alanına koyar
  const decision =
    (result && (result.check_fraudResult ?? result.return)) ??
    result;

  return String(decision || "");
}

// --------------------
// Endpoints
// --------------------
app.get("/health", (req, res) => {
  res.json({ status: "ok", service: "shieldpay-node-api" });
});

// Frankfurter hazır API proxy
// Örnek: /api/rates?from=USD&to=TRY&amount=100
app.get("/api/rates", async (req, res) => {
  try {
    const from = (req.query.from || "USD").toString().toUpperCase();
    const to = (req.query.to || "TRY").toString().toUpperCase();
    const amount = Number(req.query.amount || 100);

    const url = `https://api.frankfurter.app/latest?amount=${encodeURIComponent(
      amount
    )}&from=${encodeURIComponent(from)}&to=${encodeURIComponent(to)}`;

    const r = await axios.get(url);
    res.json({
      provider: "frankfurter",
      request: { from, to, amount },
      response: r.data,
    });
  } catch (e) {
    res.status(500).json({ error: `Rates API error: ${e.message}` });
  }
});

// REST -> SOAP fraud check
app.post("/predict", async (req, res) => {
  console.log("PREDICT HIT:", req.body);

  try {
    const { sender, receiver, amount } = req.body || {};

    if (amount === undefined || amount === null || Number.isNaN(Number(amount))) {
      return res.status(400).json({ error: "amount zorunlu ve sayısal olmalı" });
    }

    const amountNum = Number(amount);

    /**
     * riskScore (0-1) üretimi:
     * Burada ML bağlamak istersen; riskScore'u ML çıktısından alırsın.
     * Şimdilik basit: amount büyüdükçe risk artsın.
     */
    const riskScore = Math.max(0, Math.min(1, amountNum / 100000)); // 0..1
    const riskScoreInt = Math.round(riskScore * 100); // SOAP Integer bekliyor (0..100)

    const decision = await callFraudSoap(amountNum, riskScoreInt);

    const isFraud = decision.includes("FRAUD");

    return res.json({
      sender: sender ?? "A",
      receiver: receiver ?? "B",
      amount: amountNum,
      isFraud,
      fraudScore: riskScoreInt,
      fraudReason: decision,
    });
  } catch (e) {
    console.error("PREDICT ERROR:", e.message);
    return res.status(500).json({
      isFraud: false,
      fraudScore: 0,
      fraudReason: `Fraud SOAP hatası: ${e.message}`,
    });
  }
});

// --------------------
// Start
// --------------------
app.listen(PORT, () => {
  console.log(`Node API running on http://localhost:${PORT}`);
  console.log(`SOAP_WSDL_URL = ${SOAP_WSDL_URL}`);
});
