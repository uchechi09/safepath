import 'package:flutter/material.dart';
import '../services/spl_model_service.dart';
import '../widgets/risk_widgets.dart';
import 'verdict_screen.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> detectedClauses;
  final double riskScore;
  final List<ClauseInfo> clauseDetails;

  const ResultsScreen({
    super.key,
    required this.detectedClauses,
    required this.riskScore,
    required this.clauseDetails,
  });

  @override
  Widget build(BuildContext context) {
    int highCount = clauseDetails.where((c) => c.severity == 'High').length;
    int mediumCount = clauseDetails.where((c) => c.severity == 'Medium').length;

    Color riskColor;
    String riskLevel;
    if (riskScore > 40) {
      riskColor = const Color(0xFFEF4444); // Red
      riskLevel = "High Risk";
    } else if (riskScore > 15) {
      riskColor = const Color(0xFFF59E0B); // Orange
      riskLevel = "Medium Risk";
    } else {
      riskColor = const Color(0xFF10B981); // Green
      riskLevel = "Low Risk";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultHeader(onBack: () => Navigator.pop(context)),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Risk Section
                    Row(
                      children: [
                        RiskIndicator(color: riskColor),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Overall Risk Level',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              riskLevel,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: riskColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const RiskLegend(),

                    const SizedBox(height: 24),
                    SummaryHighlightCard(
                      highCount: highCount,
                      mediumCount: mediumCount,
                    ),

                    const SizedBox(height: 32),
                    _buildFlaggedHeader(context),

                    const SizedBox(height: 16),
                    if (clauseDetails.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'No significant risks detected.',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else
                      ...clauseDetails.map((info) => ClauseCard(info: info)),

                    const SizedBox(height: 32),
                    const FooterDisclaimer(),

                    const SizedBox(height: 24),
                    _buildActionBtn(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlaggedHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Flagged Clauses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        TextButton.icon(
          onPressed: () => _showAnalysisExplanation(context),
          icon: const Icon(
            Icons.help_outline,
            size: 18,
            color: Color(0xFF64748B),
          ),
          label: const Text(
            'Why?',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showAnalysisExplanation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'How we analyze your contract',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Safepath uses advanced NLP to scan for markers associated with common legal and financial risks in Terms and Conditions.',
              style: TextStyle(color: Color(0xFF64748B), height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildExplanationItem(
              'Risk Score (0-100)',
              'Calculated by comparing the severity of flagged clauses against the full set of 37 potential legal risks we track.',
            ),
            const SizedBox(height: 16),
            _buildExplanationItem(
              'High Attention',
              'Significant risks that could impact your financial liability, intellectual property, or legal rights.',
              const Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            _buildExplanationItem(
              'Review',
              'Clauses that are non-standard or operational and warrant a closer look depending on your use case.',
              const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F37C9),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Got it'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationItem(String title, String desc, [Color? dotColor]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dotColor != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 12),
            child: CircleAvatar(radius: 4, backgroundColor: dotColor),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerdictScreen(riskScore: riskScore),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3F37C9),
          foregroundColor: Colors.white,
          minimumSize: const Size(220, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Proceed',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
