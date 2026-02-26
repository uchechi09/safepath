import 'package:flutter_test/flutter_test.dart';
import 'package:safepath/services/spl_model_service.dart';

void main() {
  late SPLModelService splService;

  setUp(() {
    splService = SPLModelService();
  });

  group('SPLModelService Tests', () {
    test('detectDetailedClauses should identify Anti-Assignment clause', () {
      const text =
          'This agreement shall not be assigned by either party without the prior written consent of the other party.';
      final detected = splService.detectDetailedClauses(text);
      final names = detected.map((d) => d["name"]).toList();
      expect(names, contains('Anti-Assignment'));
      expect(detected.first["snippet"], contains('assigned by either party'));
    });

    test('detectDetailedClauses should identify multiple clauses', () {
      const text =
          'The parties agree that you shall not compete with the business. This agreement shall not be assigned by either party.';
      final detected = splService.detectDetailedClauses(text);
      final names = detected.map((d) => d["name"]).toList();
      expect(names, containsAll(['Non-Compete', 'Anti-Assignment']));
    });

    test('calculateRiskScore should return normalized value', () {
      final detected = ['Anti-Assignment', 'Non-Compete'];
      // Anti-Assignment: Severity 2
      // Non-Compete: Severity 3
      // Total matched: 5
      // Max ontology risk (from 37 clauses) is roughly around 70-80
      final score = splService.calculateRiskScore(detected);
      expect(score, greaterThan(0));
      expect(score, lessThan(100));
    });

    test(
      'getDetectedClauseDetails should return structured info with snippets',
      () {
        final detected = [
          {"name": "Non-Compete", "snippet": "not compete with the business"},
        ];
        final details = splService.getDetectedClauseDetails(detected);
        expect(details.first.name, 'Non-Compete');
        expect(details.first.severity, 'High');
        expect(details.first.originalSnippet, contains('not compete'));
        expect(details.first.plainLanguageExplanation, isNotEmpty);
      },
    );

    test(
      'Refined snippet extraction should handle mixed casing and punctuation',
      () {
        const text =
            'This is a first sentence. ALL DISPUTES SHALL BE RESOLVED THROUGH ARBITRATION! This is a third.';
        final detected = splService.detectDetailedClauses(text);
        final snippet = detected.firstWhere(
          (d) => d["name"] == "Binding Arbitration",
        )["snippet"]!;

        expect(snippet, contains('ALL DISPUTES')); // Case preservation
        expect(
          snippet,
          contains('RESOLVED THROUGH ARBITRATION!'),
        ); // Sentence boundary
        expect(snippet, isNot(contains('first sentence'))); // Isolation
      },
    );

    test('Refined snippet extraction should truncate very long sentences', () {
      final longSentence = 'Resolving disputes via binding arbitration ' * 20;
      final text = 'Intro. $longSentence End.';
      final detected = splService.detectDetailedClauses(text);
      final snippet = detected.first["snippet"]!;

      expect(snippet.length, lessThanOrEqualTo(303)); // 300 + '...'
      expect(snippet, endsWith('...'));
    });

    group('Negative Tests (Preventing False Positives)', () {
      test('Should NOT flag "assign any task" as Anti-Assignment', () {
        const text = 'You can assign any task to the junior developers.';
        final detected = splService.detectDetailedClauses(text);
        final names = detected.map((d) => d["name"]).toList();
        expect(names, isNot(contains('Anti-Assignment')));
      });

      test(
        'Should NOT flag "have the right to remain silent" as Audit Rights',
        () {
          const text = 'You have the right to remain silent.';
          final detected = splService.detectDetailedClauses(text);
          final names = detected.map((d) => d["name"]).toList();
          expect(names, isNot(contains('Audit Rights')));
        },
      );

      test('Should NOT flag "receive it" as Minimum Commitment', () {
        const text = 'Please receive it as soon as possible.';
        final detected = splService.detectDetailedClauses(text);
        final names = detected.map((d) => d["name"]).toList();
        expect(names, isNot(contains('Minimum Commitment')));
      });

      test('Should NOT flag "agree the parties" as Audit Rights or others', () {
        const text = 'We agree the parties are happy.';
        final detected = splService.detectDetailedClauses(text);
        final names = detected.map((d) => d["name"]).toList();
        expect(names, isNot(contains('Audit Rights')));
      });
    });
  });
}
