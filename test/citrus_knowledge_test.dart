import 'package:flutter_test/flutter_test.dart';
import 'package:citrus_ai/features/knowledge/domain/citrus_knowledge_model.dart';
import 'package:citrus_ai/features/recognition/domain/recognition_result.dart';

void main() {
  group('CitrusKnowledge Document Parsing Tests', () {
    final sampleOrangeDoc = <String, dynamic>{
      'scientific name': 'Citrus sinensis',
      'Calories': '47 kcal',
      'carbohydrate': '11.8 g',
      'fibre': '2.4 g',
      'sugars': '9.4 g',
      'protein': '0.9 g',
      'fat': '0.1 g',
      'vitaminC': '53.2 mg',
      'vitamin A': '225 IU',
      'Vitamin E': '0.18 mg',
      'Ca': '40 mg',
      'Fe': '0.1 mg',
      'Health benefits': 'Rich in antioxidants, strengthens immune defense.',
      'Allergy information': 'Citrus allergy is rare. May cause contact dermatitis in sensitive individuals.',
    };

    final sampleAllFiveFruits = ['Orange', 'Tangerine', 'Lemon', 'Lime', 'Kaffir Lime'];

    for (final fruit in sampleAllFiveFruits) {
      test('Successfully parses all 14 Firestore fields for $fruit', () {
        final knowledge = CitrusKnowledge.fromJson(fruit, sampleOrangeDoc);

        expect(knowledge.fruitName, equals(fruit));
        expect(knowledge.scientificName, equals('Citrus sinensis'));
        expect(knowledge.calories, equals('47 kcal'));
        expect(knowledge.carbs, equals('11.8 g'));
        expect(knowledge.fiber, equals('2.4 g'));
        expect(knowledge.sugar, equals('9.4 g'));
        expect(knowledge.protein, equals('0.9 g'));
        expect(knowledge.fat, equals('0.1 g'));
        expect(knowledge.vitaminC, equals('53.2 mg'));
        expect(knowledge.vitaminA, equals('225 IU'));
        expect(knowledge.vitaminE, equals('0.18 mg'));
        expect(knowledge.calcium, equals('40 mg'));
        expect(knowledge.iron, equals('0.1 mg'));
        expect(knowledge.healthInfo.benefits, contains('Rich in antioxidants'));
        expect(knowledge.allergyInfo.citrusAllergy, contains('Citrus allergy is rare'));
      });
    }

    test('Gracefully handles missing fields without throwing', () {
      final incompleteDoc = <String, dynamic>{
        'Calories': '45 kcal',
      };

      final knowledge = CitrusKnowledge.fromJson('Lemon', incompleteDoc);

      expect(knowledge.calories, equals('45 kcal'));
      expect(knowledge.carbs, isNull);
      expect(knowledge.scientificName, equals('Information unavailable'));
      expect(knowledge.healthInfo.benefits, equals('Information unavailable'));
      expect(knowledge.allergyInfo.citrusAllergy, equals('Information unavailable'));
    });
  });

  group('RecognitionResult & Confidence Threshold Tests', () {
    test('Identifies valid class above 60% confidence as supported', () {
      const res = RecognitionResult(
        predictedClass: 'Orange',
        confidence: 0.85,
        imagePath: '/path/to/image.jpg',
        allScores: {'Orange': 0.85, 'Lemon': 0.05, 'Lime': 0.04, 'Tangerine': 0.04, 'Kaffir Lime': 0.02},
        isSupported: true,
      );

      expect(res.isSupported, isTrue);
      expect(res.confidencePercentage, equals('85.0%'));
    });

    test('Rejects prediction below 60% confidence threshold', () {
      final res = RecognitionResult.unsupported(
        imagePath: '/path/to/image.jpg',
        highestConfidence: 0.55,
        tentativeClass: 'Orange',
      );

      expect(res.isSupported, isFalse);
    });

    test('Rejects unsupported fruit class even with high confidence', () {
      final res = RecognitionResult.unsupported(
        imagePath: '/path/to/image.jpg',
        highestConfidence: 0.95,
        tentativeClass: 'Grapefruit',
      );

      expect(res.isSupported, isFalse);
    });
  });
}

