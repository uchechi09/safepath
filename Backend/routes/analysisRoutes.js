const express = require("express");
const router = express.Router();

// TEST ROUTE
router.get("/", (req, res) => {
  res.json({
    message: "Analysis route is working"
  });
});

// ANALYZE TERMS ROUTE
router.post("/analysis", (req, res) => {
  const { text } = req.body;

  if (!text) {
    return res.status(400).json({
      message: "No text provided"
    });
  }

  // Temporary fake AI logic (we will replace this with real AI later)
  let riskLevel = "Low";
  let flaggedClauses = [];

  if (text.toLowerCase().includes("binding arbitration")) {
    riskLevel = "High";
    flaggedClauses.push("Binding Arbitration Clause");
  }

  if (text.toLowerCase().includes("auto-renewal")) {
    riskLevel = "Medium";
    flaggedClauses.push("Auto Renewal Clause");
  }

  res.json({
    overallRisk: riskLevel,
    flaggedClauses: flaggedClauses
  });
});

module.exports = router;
