class ClauseInfo {
  final String name;
  final String severity;
  final int severityScore;
  final String warningMessage;
  final String plainLanguageExplanation;
  final String whyItMatters;
  final String originalSnippet;

  ClauseInfo({
    required this.name,
    required this.severity,
    required this.severityScore,
    required this.warningMessage,
    this.plainLanguageExplanation = "",
    this.whyItMatters = "",
    this.originalSnippet = "",
  });
}

class SPLModelService {
  static const Map<String, String> _severityMapping = {
    "Uncapped Liability": "High",
    "Minimum Commitment": "High",
    "Termination For Convenience": "High",
    "Exclusivity": "High",
    "Non-Compete": "High",
    "Ip Ownership Assignment": "High",
    "Liquidated Damages": "High",
    "Binding Arbitration": "High",
    "Auto-Renewal Clause": "High",
    "Audit Rights": "Medium",
    // ... rest of mapping
    "Revenue/Profit Sharing": "Medium",
    "Anti-Assignment": "Medium",
    "Cap On Liability": "Medium",
    "Volume Restriction": "Medium",
    "Most Favored Nation": "Medium",
    "Rofr/Rofo/Rofn": "Medium",
    "Affiliate License-Licensor": "Medium",
    "Affiliate License-Licensee": "Medium",
    "Change Of Control": "Medium",
    "No-Solicit Of Employees": "Medium",
    "No-Solicit Of Customers": "Medium",
    "Competitive Restriction Exception": "Medium",
    "Post-Termination Services": "Medium",
    "Price Restrictions": "Medium",
    "Irrevocable Or Perpetual License": "Medium",
    "Source Code Escrow": "Medium",
    "Warranty Duration": "Low",
    "Non-Disparagement": "Low",
    "Unlimited/All-You-Can-Eat-License": "Low",
    "Renewal Term": "Low",
    "Notice Period To Terminate Renewal": "Low",
    "Governing Law": "Low",
    "Joint Ip Ownership": "Low",
    "License Grant": "Low",
    "Non-Transferable License": "Low",
    "Insurance": "Low",
    "Covenant Not To Sue": "Low",
    "Third Party Beneficiary": "Low",
  };

  static const Map<String, String> _warningMessages = {
    "Anti-Assignment":
        "This clause may require attention depending on your situation. This relates to operational risk.",
    "Cap On Liability":
        "This clause may require attention depending on your situation. This relates to financial risk.",
    "Termination For Convenience":
        "This clause may significantly affect your rights or obligations. This relates to operational risk.",
    "Exclusivity":
        "This clause may significantly affect your rights or obligations. This relates to strategic restriction risk.",
    "Minimum Commitment":
        "This clause may significantly affect your rights or obligations. This relates to financial risk.",
    "Audit Rights":
        "This clause may require attention depending on your situation. This relates to operational risk.",
    "Ip Ownership Assignment":
        "This clause may significantly affect your rights or obligations. This relates to intellectual property risk.",
    "Post-Termination Services":
        "This clause may require attention depending on your situation. This relates to operational risk.",
    "Non-Compete":
        "This clause may significantly affect your rights or obligations. This relates to strategic restriction risk.",
    "Uncapped Liability":
        "This clause may significantly affect your rights or obligations. This relates to financial risk.",
    "Revenue/Profit Sharing":
        "This clause may require attention depending on your situation. This relates to financial risk.",
    "License Grant":
        "This clause is generally informational but still important to review. This relates to intellectual property risk.",
    "Change Of Control":
        "This clause may require attention depending on your situation. This relates to operational risk.",
    "Liquidated Damages":
        "This clause may significantly affect your rights or obligations. This relates to financial risk.",
    "Rofr/Rofo/Rofn":
        "This clause may require attention depending on your situation. This relates to strategic restriction risk.",
    "Binding Arbitration":
        "This clause limits your ability to take disputes to court.",
    "Auto-Renewal Clause":
        "This subscription renews automatically and may charge you without prior reminder.",
  };

  static const Map<String, String> _plainExplanations = {
    "Binding Arbitration":
        "If you have a problem with this service, you cannot sue them in court or join a group lawsuit. You must use a private arbitrator chosen by the company.",
    "Auto-Renewal Clause":
        "This service will automatically renew and bill you unless you explicitly cancel it within a specific timeframe.",
  };

  static const Map<String, String> _whyMatters = {
    "Binding Arbitration":
        "Arbitration can limit your legal options and make it harder to hold companies accountable. You lose the right to a jury trial and the ability to join with other affected customers.",
    "Auto-Renewal Clause":
        "It prevents service interruption but can lead to unwanted charges if you forget to cancel. It shifts the burden of contract management onto the user.",
  };

  static const Map<String, List<String>> _rules = {
    "Binding Arbitration": [
      r"\barbitration\b",
      r"\bdispute\w*.*?\bresol\w*",
      r"\bresol\w*.*?\bdispute\w*",
      r"\bwaive\b.*?\bclass\b.*?\baction\b",
    ],
    "Auto-Renewal Clause": [
      r"\brenew\w*.*?\bautomatic\w*",
      r"\bautomatic\w*.*?\brenew\w*",
      r"\bsubsequent\b.*?\bterm\b",
    ],
    "Anti-Assignment": [
      r"\bassign\w*.*?\bconsent\b",
      r"\bconsent\b.*?\bassign\w*",
      r"\bneither\b.*?\bparty\b.*?\bassign\w*",
      r"\bassign\w*.*?\bparty\b",
    ],
    "Cap On Liability": [
      r"\bcap\b.*?\bliability\b",
      r"\blimit\w*.*?\bliability\b",
      r"\bloss\b.*?\bof\b.*?\bprofits\b",
      r"\bpunitive\b.*?\bdamages\b",
      r"\bconsequential\b.*?\bdamages\b",
    ],
    "Termination For Convenience": [
      r"\bterminate\b.*?\bconvenience\b",
      r"\bterminate\b.*?\bwithout\b.*?\bcause\b",
      r"\bterminate\b.*?\bat\b.*?\bany\b.*?\btime\b",
    ],
    "Exclusivity": [
      r"\bexclusive\b.*?\bright\b",
      r"\bexclusive\b.*?\blicense\b",
    ],
    "Minimum Commitment": [
      r"\bminimum\b.*?\bcommitment\b",
      r"\bminimum\b.*?\bpurchase\b",
    ],
    "Audit Rights": [
      r"\baudit\b.*?\bright\w*",
      r"\bright\w*.*?\baudit\b",
      r"\baudit\b.*?\brecord\w*",
      r"\binspect\b.*?\brecord\w*",
    ],
    "Ip Ownership Assignment": [
      r"\bassign\w*.*?\bintellectual\s+property\b",
      r"\bwork\b.*?\bmade\b.*?\bfor\b.*?\bhire\b",
      r"\bown\w*.*?\bintellectual\s+property\b",
    ],
    "Post-Termination Services": [
      r"\bpost\b.*?\btermination\b",
      r"\bfollowing\b.*?\btermination\b",
    ],
    "Non-Compete": [r"\bnot\b.*?\bcompete\b", r"\bnon\b.*?\bcompete\b"],
    "Uncapped Liability": [
      r"\buncapped\b.*?\bliability\b",
      r"\bunlimited\b.*?\bliability\b",
    ],
    "Revenue/Profit Sharing": [
      r"\brevenue\b.*?\bsharing\b",
      r"\bprofit\b.*?\bsharing\b",
      r"\broyalty\b",
    ],
    "License Grant": [
      r"\bgrant\w*.*?\blicense\b",
      r"\blicense\w*.*?\bgrant\w*",
    ],
    "Change Of Control": [
      r"\bchange\b.*?\bof\b.*?\bcontrol\b",
      r"\bmerger\b.*?\bacquisition\b",
    ],
    "Liquidated Damages": [r"\bliquidated\b.*?\bdamages\b"],
    "Rofr/Rofo/Rofn": [
      r"\bright\b.*?\bof\b.*?\bfirst\b.*?\brefusal\b",
      r"\bright\b.*?\bof\b.*?\bfirst\s+offer\b",
    ],
  };

  List<Map<String, String>> detectDetailedClauses(String contractText) {
    List<Map<String, String>> detected = [];

    _rules.forEach((clause, patterns) {
      for (var pattern in patterns) {
        // Match against original text but case-insensitive
        RegExp regExp = RegExp(pattern, caseSensitive: false, dotAll: true);
        var match = regExp.firstMatch(contractText);
        if (match != null) {
          detected.add({
            "name": clause,
            "snippet": _extractRefinedSnippet(contractText, match),
          });
          break;
        }
      }
    });

    return detected;
  }

  String _extractRefinedSnippet(String fullText, Match match) {
    int start = match.start;
    int end = match.end;

    // Expand search for sentence start (look back)
    int sentenceStart = start;
    while (sentenceStart > 0) {
      String prevChar = fullText[sentenceStart - 1];
      if (prevChar == '.' ||
          prevChar == '!' ||
          prevChar == '?' ||
          prevChar == '\n') {
        break;
      }
      sentenceStart--;
    }

    // Expand search for sentence end (look forward)
    int sentenceEnd = end;
    while (sentenceEnd < fullText.length) {
      String nextChar = fullText[sentenceEnd];
      if (nextChar == '.' ||
          nextChar == '!' ||
          nextChar == '?' ||
          nextChar == '\n') {
        sentenceEnd++; // Include the punctuation
        break;
      }
      sentenceEnd++;
    }

    String snippet = fullText.substring(sentenceStart, sentenceEnd).trim();

    // Secondary truncation if the "sentence" is still too long or lacks punctuation
    const int maxLen = 300;
    if (snippet.length > maxLen) {
      // Find a space near the limit to avoid cutting words
      int lastSpace = snippet.lastIndexOf(' ', maxLen);
      snippet =
          "${snippet.substring(0, lastSpace > 0 ? lastSpace : maxLen)}...";
    }

    return snippet.isEmpty ? "Condition found in text." : snippet;
  }

  double calculateRiskScore(List<String> detectedClauses) {
    if (detectedClauses.isEmpty) return 0.0;

    double currentRiskScore = 0;
    for (var clause in detectedClauses) {
      currentRiskScore += _getSeverityScore(clause);
    }

    double maxOntologyRisk = 0;
    _severityMapping.forEach((clause, severity) {
      maxOntologyRisk += _getSeverityScore(clause);
    });

    if (maxOntologyRisk == 0) return 0.0;

    double score = (currentRiskScore / maxOntologyRisk) * 100;
    return score > 100 ? 100.0 : score;
  }

  int _getSeverityScore(String clause) {
    String severity = _severityMapping[clause] ?? "Low";
    switch (severity) {
      case "High":
        return 3;
      case "Medium":
        return 2;
      case "Low":
      default:
        return 1;
    }
  }

  List<ClauseInfo> getDetectedClauseDetails(
    List<Map<String, String>> detected,
  ) {
    return detected.map((d) {
      String clauseName = d["name"]!;
      String snippet = d["snippet"]!;

      return ClauseInfo(
        name: clauseName,
        severity: _severityMapping[clauseName] ?? "Low",
        severityScore: _getSeverityScore(clauseName),
        warningMessage: _warningMessages[clauseName] ?? "No specific warning.",
        plainLanguageExplanation:
            _plainExplanations[clauseName] ??
            "This clause might affect your rights. Please review the original text carefully.",
        whyItMatters:
            _whyMatters[clauseName] ??
            "Understanding these terms is crucial before accepting the agreement to avoid future legal or financial issues.",
        originalSnippet: snippet,
      );
    }).toList();
  }
}
