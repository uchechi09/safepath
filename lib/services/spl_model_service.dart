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
      "resolve.*dispute",
      "dispute.*resolve",
      "binding.*arbitration",
      "waive.*class.*action",
      "individual.*basis",
    ],
    "Auto-Renewal Clause": [
      "renew.*automatically",
      "automatic.*renewal",
      "subsequent.*term",
    ],
    "Anti-Assignment": [
      "assign.*this.*agreement",
      "write.*the.*prior.*written.*consent",
      "write.*the.*other.*party",
      "assign.*neither.*party",
      "assign.*its.*rights",
      "write.*this.*agreement",
      "assign.*any",
      "assign.*either.*party",
      "hereunder.*obligations",
      "write.*prior.*written.*consent",
    ],
    "Cap On Liability": [
      "advise.*the.*possibility",
      "relate.*this.*agreement",
      "include.*negligence",
      "arise.*this.*agreement",
      "include.*contract",
      "arise.*connection",
      "lose.*lost.*profits",
      "punitive.*damages",
      "give.*rise",
      "include.*damages",
    ],
    "Termination For Convenience": [
      "terminate.*this.*agreement",
      "write.*notice",
      "terminate.*either.*party",
      "write.*written.*notice",
      "terminate.*any.*time",
      "write.*prior.*written.*notice",
      "write.*the.*other.*party",
      "terminate.*the.*right",
      "have.*the.*right",
      "write.*any.*time",
    ],
    "Exclusivity": [
      "have.*the.*exclusive.*right",
      "sell.*market",
      "offer.*sale",
      "set.*this.*agreement",
      "sublicense.*the.*right",
      "include.*limitation",
      "grant.*the.*right",
      "grant.*sublicenses",
      "set.*the.*terms",
      "sell.*the.*exclusive.*right",
    ],
    "Minimum Commitment": [
      "terminate.*this.*agreement",
      "agree.*the.*parties",
      "write.*written.*notice",
      "have.*the.*right",
      "follow.*the.*following.*dates",
      "terminate.*the.*right",
      "fail.*the.*event",
      "follow.*july",
      "detect.*delay",
      "receive.*it",
    ],
    "Audit Rights": [
      "have.*the.*right",
      "verify.*the.*accuracy",
      "audit.*the.*audited.*party",
      "audit.*records",
      "inspect.*the.*right",
      "audit.*the.*right",
      "have.*we",
      "write.*written.*notice",
      "conduct.*the.*right",
      "agree.*the.*parties",
    ],
    "Ip Ownership Assignment": [
      "make.*hire",
      "assign.*the.*company",
      "agree.*you",
      "include.*limitation",
      "agree.*consultant",
      "assign.*all",
      "agree.*the.*company",
      "assign.*all.*rights",
      "assign.*title",
      "assign.*xencor",
    ],
    "Post-Termination Services": [
      "terminate.*this.*agreement",
      "follow.*termination",
      "pay.*pb",
      "include.*the.*trial.*data.*package",
      "pay.*sfj",
      "include.*the.*research.*results",
      "terminate.*the.*event",
      "have.*the.*right",
      "set.*section",
      "provide.*section",
    ],
    "Non-Compete": [
      "have.*any.*interest",
      "agree.*you",
      "agree.*the.*term",
      "provide.*services",
      "terminate.*this.*agreement",
      "compete.*which",
      "approve.*writing",
      "compete.*the.*business",
      "offer.*which",
      "reverse.*auctions",
    ],
    "Uncapped Liability": [
      "advise.*the.*possibility",
      "include.*negligence",
      "relate.*this.*agreement",
      "lose.*lost.*profits",
      "punitive.*damages",
      "include.*contract",
      "arise.*liability",
      "advise.*such.*party",
      "arise.*this.*agreement",
      "arise.*damages",
    ],
    "Revenue/Profit Sharing": [
      "pay.*verticalnet",
      "pay.*licensee",
      "share.*the.*parties",
      "pay.*a.*royalty",
      "pay.*paperexchange",
      "earn.*licensee",
      "ship.*\\*",
      "set.*section",
      "pay.*neoforma",
      "pay.*a.*commission",
    ],
    "License Grant": [
      "use.*the.*right",
      "offer.*sale",
      "make.*use",
      "grant.*this.*agreement",
      "grant.*the.*right",
      "sell.*sale",
      "include.*the.*right",
      "have.*the.*right",
      "sell.*use",
      "sublicense.*the.*right",
    ],
    "Change Of Control": [
      "terminate.*this.*agreement",
      "assign.*this.*agreement",
      "write.*written.*notice",
      "have.*the.*right",
      "write.*this.*agreement",
      "provide.*this.*agreement",
      "undergo.*control",
      "write.*the.*prior.*written.*consent",
      "write.*the.*other.*party",
      "provide.*services",
    ],
    "Liquidated Damages": [
      "liquidate.*liquidated.*damages",
      "terminate.*this.*agreement",
      "liquidate.*the.*liquidated.*damages",
      "pay.*party.*b",
      "liquidate.*party.*b",
      "pay.*the.*liquidated.*damages",
      "terminate.*the.*agreement",
      "pay.*customer",
      "entitle.*party.*a",
      "request.*party.*b",
    ],
    "Rofr/Rofo/Rofn": [
      "write.*written.*notice",
      "have.*the.*right",
      "provide.*written.*notice",
      "enter.*an.*agreement",
      "negotiate.*good.*faith",
      "exercise.*its.*option",
      "include.*which",
      "provide.*bii",
      "write.*it",
      "set.*section",
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
