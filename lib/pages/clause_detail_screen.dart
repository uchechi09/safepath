import 'package:flutter/material.dart';
import '../services/spl_model_service.dart';

class ClauseDetailScreen extends StatelessWidget {
  final ClauseInfo info;

  const ClauseDetailScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    Color riskColor;
    if (info.severity == 'High') {
      riskColor = const Color(0xFFEF4444);
    } else if (info.severity == 'Medium') {
      riskColor = const Color(0xFFF59E0B);
    } else {
      riskColor = const Color(0xFF10B981);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Back link
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Back to overview',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    // Risk Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: riskColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${info.severity.toUpperCase()} RISK',
                        style: TextStyle(
                          color: riskColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Clause Name
                    Text(
                      info.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),

                    const SizedBox(height: 32),
                    // Original Text Section
                    const _SectionHeader(title: 'ORIGINAL CONTRACT TEXT'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        '"${info.originalSnippet}"',
                        style: const TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    // Plain Language Section
                    const _SectionHeader(title: 'PLAIN LANGUAGE EXPLANATION'),
                    _buildInfoBox(
                      content: info.plainLanguageExplanation,
                      icon: Icons.info_outline,
                      color: const Color(0xFF3F37C9),
                      bgColor: const Color(0xFFEFF6FF),
                      borderColor: const Color(0xFFDBEAFE),
                    ),

                    const SizedBox(height: 32),
                    // Why This Matters Section
                    const _SectionHeader(title: 'WHY THIS MATTERS'),
                    _buildInfoBox(
                      content: info.whyItMatters,
                      icon: Icons.warning_amber_rounded,
                      color: const Color(0xFFEF4444),
                      bgColor: const Color(0xFFFEF2F2),
                      borderColor: const Color(0xFFFEE2E2),
                    ),

                    const SizedBox(height: 48),
                    // Footer disclaimer
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'This analysis is provided for informational purposes. Consider consulting a legal professional for specific advice about your situation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Safepath Lite',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Contract Risk Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required String content,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF475569),
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1E293B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
