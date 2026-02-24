import 'package:flutter/material.dart';
import '../services/spl_model_service.dart';
import '../pages/clause_detail_screen.dart';

class ResultHeader extends StatelessWidget {
  final VoidCallback onBack;

  const ResultHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.chevron_left, color: Color(0xFF1E293B)),
                onPressed: onBack,
              ),
              const SizedBox(width: 8),
              const Text(
                'Safepath Lite',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              'Contract Risk Overview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RiskIndicator extends StatelessWidget {
  final Color color;
  const RiskIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.15),
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RiskLegend extends StatelessWidget {
  const RiskLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _legendItem('Low-Save', const Color(0xFF10B981)),
        _divider(),
        _legendItem('Medium-Review', const Color(0xFFF59E0B)),
        _divider(),
        _legendItem('High-High Attention', const Color(0xFFEF4444)),
      ],
    );
  }

  Widget _legendItem(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '|',
        style: TextStyle(color: Colors.grey.withValues(alpha: 0.3)),
      ),
    );
  }
}

class SummaryHighlightCard extends StatelessWidget {
  final int highCount;
  final int mediumCount;

  const SummaryHighlightCard({
    super.key,
    required this.highCount,
    required this.mediumCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                '${highCount + mediumCount} clauses Flagged',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$highCount high risk, $mediumCount medium risk',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFB45309),
            ),
          ),
        ],
      ),
    );
  }
}

class ClauseCard extends StatelessWidget {
  final ClauseInfo info;
  const ClauseCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    if (info.severity == 'High') {
      textColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEE2E2);
    } else if (info.severity == 'Medium') {
      textColor = const Color(0xFFB45309);
      bgColor = const Color(0xFFFEF3C7);
    } else {
      textColor = const Color(0xFF065F46);
      bgColor = const Color(0xFFDCFCE7);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              info.severity == 'High' ? 'High Risk' : '${info.severity} risk',
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            info.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            info.warningMessage,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClauseDetailScreen(info: info),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Why is this risky',
                  style: TextStyle(
                    color: Color(0xFF3F37C9),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFF3F37C9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterDisclaimer extends StatelessWidget {
  const FooterDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: const Column(
        children: [
          Text(
            'Review before Accepting',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF475569),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'SafePath provides informational guidance only',
            style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}
