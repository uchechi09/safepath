import 'package:flutter/material.dart';

class VerdictScreen extends StatelessWidget {
  final double riskScore;

  const VerdictScreen({super.key, required this.riskScore});

  @override
  Widget build(BuildContext context) {
    String imagePath;
    String title;
    String description;
    Color primaryColor;

    if (riskScore > 40) {
      imagePath = 'assets/images/high_risk.png';
      title = 'High Alert!';
      description =
          'Several high-risk clauses were detected. We strongly recommend consulting a legal professional before signing this agreement.';
      primaryColor = const Color(0xFFEF4444);
    } else if (riskScore > 15) {
      imagePath = 'assets/images/medium_risk.png';
      title = 'Proceed with Caution';
      description =
          'Some non-standard clauses were detected. Please review the flagged items carefully to ensure they align with your expectations.';
      primaryColor = const Color(0xFFF59E0B);
    } else {
      imagePath = 'assets/images/low_risk.png';
      title = 'All Good!';
      description =
          'The Terms & Conditions have no highly risky clauses detected. You can proceed with more confidence.';
      primaryColor = const Color(0xFF10B981);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Shield Image
              Image.asset(imagePath, height: 180, fit: BoxFit.contain),
              const SizedBox(height: 48),
              // Verdict Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  height: 1.6,
                ),
              ),
              const Spacer(),
              // Action Button
              ElevatedButton(
                onPressed: () {
                  // Pop back explicitly to the scan input session
                  Navigator.of(
                    context,
                  ).popUntil((route) => route.settings.name == '/analyze');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F37C9),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Back to Scan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
