SafePath Lite (SPL) – Local Rule Engine Specification
1. Overview

SafePath Lite (SPL) is a rule-based transparency engine that analyzes Terms and Conditions text and flags high-risk contractual clauses.

The system runs locally and produces structured JSON output that can be consumed by a Flutter mobile application or browser extension UI.

This document defines:

Input format

Rule structure

Risk severity mapping

Output JSON structure

How the mobile app should consume the result

2. System Architecture (Local Mode)

The SPL engine operates using:

rules.json → Defines keyword patterns and clause categories

severity_mapping.json → Maps risk levels (Green/Yellow/Red)

warning_messages.json → Stores user-facing explanations

Contract text (input) → Raw Terms & Conditions string

The engine processes text using deterministic rule-based matching (Regex + keyword clusters).

No external APIs are required.

3. Input Format

The engine receives raw contract text as a string.

Example:

"We may automatically renew your subscription unless cancelled 48 hours before the billing date. Late payments incur a 15% penalty."

Input Type:

Plain text (String)

4. Rule Structure (rules.json)

Each rule must follow this structure:

{
  "id": "AUTO_RENEWAL_001",
  "category": "Auto Renewal",
  "keywords": ["automatically renew", "recurring billing", "subscription renewal"],
  "severity": "YELLOW"
}

Field Explanation:

id → Unique identifier for the rule

category → Risk category name

keywords → Words or phrases to detect

severity → Risk level (GREEN, YELLOW, RED)

5. Severity Mapping (severity_mapping.json)
{
  "GREEN": "Low Risk",
  "YELLOW": "Moderate Risk",
  "RED": "High Risk"
}

Traffic Light Meaning:

GREEN → Informational

YELLOW → Caution

RED → High Risk / Potentially Harmful

6. Warning Messages (warning_messages.json)

Each category must have a user-friendly explanation.

Example:

{
  "Auto Renewal": "This agreement may automatically renew your subscription without clear notice.",
  "Hidden Fees": "This clause may include undisclosed penalties or additional charges."
}

These messages are displayed directly to users in the UI.

7. Output JSON Structure (FINAL FORMAT)

This is the standardized output format that the mobile application must consume.

{
  "overall_risk": "HIGH",
  "flags": [
    {
      "rule_id": "AUTO_RENEWAL_001",
      "category": "Auto Renewal",
      "severity": "YELLOW",
      "message": "This agreement may automatically renew your subscription without clear notice.",
      "matched_text": "automatically renew your subscription"
    }
  ]
}

Field Explanation:

overall_risk → Highest severity detected (LOW, MEDIUM, HIGH)

flags → List of all triggered rules

rule_id → ID of matched rule

category → Risk type

severity → Traffic level (GREEN/YELLOW/RED)

message → User explanation

matched_text → Exact phrase found in contract

8. Overall Risk Calculation Logic

The engine calculates overall risk using the highest severity found:

If any RED exists → overall_risk = HIGH

Else if any YELLOW exists → overall_risk = MEDIUM

Else → overall_risk = LOW

9. Mobile App Integration (Flutter)

The Flutter application should:

Receive the structured JSON output.

Display overall risk using a traffic light indicator.

Render each flagged clause in a scrollable list.

Highlight the matched text inside the contract view.

Allow users to tap a flag to read the warning message.

The mobile app should not modify detection logic.
It should only consume and display the structured output.

10. Privacy and Security

All processing runs locally.

No external API calls are required.

No contract data is stored permanently.

No user data is transmitted externally.

This ensures privacy preservation and deterministic output.

11. Scope (MVP)

The MVP includes:

Rule-based detection

Severity categorization

Structured JSON output

Traffic light UI support

The MVP does not include:

Machine learning predictions

Cloud-based processing

User account management

Data storage

12. Developer Responsibilities

Backend/Data:

Maintain rule consistency

Ensure JSON structure validity

Standardize output format

Mobile Developer:

Consume structured JSON

Build UI components based on severity levels

Implement visual highlighting