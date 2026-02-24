import 'package:flutter/material.dart';
import 'onboarding_design.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen>
    with TickerProviderStateMixin {
  bool _isAnalyzing = false;
  final TextEditingController _controller = TextEditingController();

  void _startAnalysis() {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste some terms first')),
      );
      return;
    }
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate analysis delay
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        // Navigation to results page would go here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SafePath Lite',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1),
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isAnalyzing
              ? _ScanningStateView()
              : _InputStateView(
                  controller: _controller,
                  onAnalyze: _startAnalysis,
                ),
        ),
      ),
    );
  }
}

class _InputStateView extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAnalyze;

  const _InputStateView({required this.controller, required this.onAnalyze});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paste the agreement below:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "We'll highlight potential risk clauses instantly",
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              ),
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText:
                      'Paste Terms, policies, or agreements here.........',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: onAnalyze,
              style: ElevatedButton.styleFrom(
                backgroundColor: OnboardingDesign.primaryBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(220, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Analyze Terms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ScanningStateView extends StatefulWidget {
  @override
  State<_ScanningStateView> createState() => _ScanningStateViewState();
}

class _ScanningStateViewState extends State<_ScanningStateView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Animated Scanning Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                OnboardingDesign.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 60),
          // Visual Representation of document scanning
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Stack(
              children: [
                // Simulating scanned lines
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: List.generate(
                      8,
                      (index) => Container(
                        height: 6,
                        margin: const EdgeInsets.only(bottom: 8),
                        width: index % 2 == 0 ? double.infinity : 200,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                ),
                // Scanning Line Animation
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Positioned(
                      top: 180 * _controller.value,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: OnboardingDesign.primaryBlue.withValues(
                                alpha: 0.5,
                              ),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          color: OnboardingDesign.primaryBlue,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analyzing content..........',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Detecting risky clauses..............',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
