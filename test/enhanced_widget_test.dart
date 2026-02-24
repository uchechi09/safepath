import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safepath/pages/clause_detail_screen.dart';
import 'package:safepath/pages/verdict_screen.dart';
import 'package:safepath/services/spl_model_service.dart';

void main() {
  group('Enhanced Widget Tests', () {
    testWidgets('ClauseDetailScreen should display provided clause info', (
      WidgetTester tester,
    ) async {
      final info = ClauseInfo(
        name: 'Binding Arbitration',
        severity: 'High',
        severityScore: 3,
        warningMessage: 'Limits your legal options.',
        plainLanguageExplanation: 'You cannot sue them in court.',
        whyItMatters: 'Arbitration is private and may be biased.',
        originalSnippet: 'ALL DISPUTES SHALL BE RESOLVED BY ARBITRATION.',
      );

      await tester.pumpWidget(
        MaterialApp(home: ClauseDetailScreen(info: info)),
      );

      // Check for key content
      expect(find.text('Binding Arbitration'), findsOneWidget);
      expect(find.text('HIGH RISK'), findsOneWidget);
      expect(
        find.text('"ALL DISPUTES SHALL BE RESOLVED BY ARBITRATION."'),
        findsOneWidget,
      );
      expect(find.text('You cannot sue them in court.'), findsOneWidget);
      expect(
        find.text('Arbitration is private and may be biased.'),
        findsOneWidget,
      );
    });

    testWidgets('VerdictScreen should show "All Good!" for low risk', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: VerdictScreen(riskScore: 5.0)),
      );

      expect(find.text('All Good!'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Back to Scan'), findsOneWidget);
    });

    testWidgets('VerdictScreen should show "High Alert!" for high risk', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: VerdictScreen(riskScore: 65.0)),
      );

      expect(find.text('High Alert!'), findsOneWidget);
    });
  });
}
