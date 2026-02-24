import 'package:flutter/material.dart';
import 'analyze_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'IMPORTANCE NOTICE',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.withValues(alpha: 0.05),
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
        child: Column(
          children: [
            const Text(
              'SafePath provides automated risk analysis for informational purposes only. It does not provide legal advice. Always consult a qualified legal professional before making legal decisions.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF475569),
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _isAccepted,
                    onChanged: (value) {
                      setState(() {
                        _isAccepted = value ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(
                      color: Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                    activeColor: const Color(0xFF3F37C9),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'I understand that SafePath does not provide legal advice.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _isAccepted
                  ? () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('has_accepted_agreement', true);
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: '/analyze'),
                          builder: (context) => const AnalyzeScreen(),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F37C9),
                disabledBackgroundColor: const Color(
                  0xFF3F37C9,
                ).withValues(alpha: 0.5),
                foregroundColor: Colors.white,
                minimumSize: const Size(180, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Get started',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 120), // Spacing from bottom as in image
          ],
        ),
      ),
    );
  }
}
