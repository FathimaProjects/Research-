class CitrusKnowledge {
  final String fruitName;
  final String scientificName;
  final String commonName;
  final String servingSize;
  final Map<String, String> nutrition;
  final AllergyInfo allergyInfo;
  final HealthInfo healthInfo;

  const CitrusKnowledge({
    required this.fruitName,
    required this.scientificName,
    required this.commonName,
    required this.servingSize,
    required this.nutrition,
    required this.allergyInfo,
    required this.healthInfo,
  });

  String? get calories => nutrition['calories'];
  String? get carbs => nutrition['carbs'];
  String? get sugar => nutrition['sugar'];
  String? get fiber => nutrition['fiber'];
  String? get protein => nutrition['protein'];
  String? get fat => nutrition['fat'];
  String? get vitaminC => nutrition['vitaminC'];
  String? get vitaminA => nutrition['vitaminA'];
  String? get vitaminE => nutrition['vitaminE'];
  String? get calcium => nutrition['calcium'];
  String? get iron => nutrition['iron'];

  factory CitrusKnowledge.fromJson(String fruit, Map<String, dynamic> json) {
    // Helper to find field value across multiple potential naming/casing variations
    String? findVal(List<String> candidateKeys) {
      for (final key in candidateKeys) {
        if (json.containsKey(key) && json[key] != null) {
          final val = json[key].toString().trim();
          if (val.isNotEmpty) return val;
        }
      }
      // Case-insensitive lookup (ignoring spaces & underscores)
      for (final entry in json.entries) {
        final cleanKey = entry.key.replaceAll(' ', '').replaceAll('_', '').toLowerCase();
        for (final candidate in candidateKeys) {
          if (cleanKey == candidate.replaceAll(' ', '').replaceAll('_', '').toLowerCase()) {
            final val = entry.value?.toString().trim();
            if (val != null && val.isNotEmpty) return val;
          }
        }
      }
      return null;
    }

    // Parse nutrition map: support both flat document fields and nested 'nutrition' map
    final Map<String, String> nutritionMap = {};

    // 1. If document has a nested 'nutrition' map, copy its entries
    if (json['nutrition'] is Map<String, dynamic>) {
      (json['nutrition'] as Map<String, dynamic>).forEach((k, v) {
        nutritionMap[k] = v.toString();
      });
    }

    // 2. Map flat Firestore fields to standard keys expected by NutritionScreen
    void setIfFound(String standardKey, List<String> aliases) {
      final val = findVal(aliases);
      if (val != null) {
        nutritionMap[standardKey] = val;
      }
    }

    setIfFound('calories', ['Calories', 'calories', 'Energy', 'energy']);
    setIfFound('carbs', ['carbohydrate', 'carbohydrates', 'Carbohydrate', 'Carbohydrates', 'carbs']);
    setIfFound('sugar', ['sugars', 'sugar', 'Sugars', 'Sugar']);
    setIfFound('fiber', ['fibre', 'fiber', 'Fibre', 'Fiber']);
    setIfFound('protein', ['protein', 'Protein']);
    setIfFound('fat', ['fat', 'Fat']);
    setIfFound('vitaminC', ['vitaminC', 'vitamin C', 'Vitamin C', 'VitaminC']);
    setIfFound('vitaminA', ['vitamin A', 'vitaminA', 'Vitamin A', 'VitaminA']);
    setIfFound('vitaminE', ['Vitamin E', 'vitamin E', 'vitaminE', 'VitaminE']);
    setIfFound('calcium', ['Ca', 'ca', 'Calcium', 'calcium']);
    setIfFound('iron', ['Fe', 'fe', 'Iron', 'iron']);

    // Parse allergy information (from flat 'Allergy information' or nested 'allergyInfo')
    final allergyText = findVal([
          'Allergy information',
          'allergy information',
          'Allergy Information',
          'allergyInfo',
          'citrusAllergy'
        ]) ??
        'Information unavailable';

    // Parse health benefits (from flat 'Health benefits' or nested 'healthInfo')
    final healthBenefitsText = findVal([
          'Health benefits',
          'health benefits',
          'Health Benefits',
          'healthInfo',
          'benefits'
        ]) ??
        'Information unavailable';

    final sciName = findVal(['scientific name', 'scientificName', 'Scientific name', 'scientific_name']) ??
        'Information unavailable';
    final comName = findVal(['common name', 'commonName', 'Common name', 'common_name']) ?? fruit;
    final sSize = findVal(['serving size', 'servingSize', 'Serving size', 'serving_size']) ?? 'Per 100 g';

    return CitrusKnowledge(
      fruitName: fruit,
      scientificName: sciName,
      commonName: comName,
      servingSize: sSize,
      nutrition: nutritionMap,
      allergyInfo: AllergyInfo(
        citrusAllergy: allergyText,
        crossReactivity: findVal(['crossReactivity', 'cross reactivity']) ?? 'Information unavailable',
        sensitivityAdvice: findVal(['sensitivityAdvice', 'sensitivity advice']) ?? 'Information unavailable',
      ),
      healthInfo: HealthInfo(
        benefits: healthBenefitsText,
        storageRecommendation:
            findVal(['storageRecommendation', 'storage recommendation', 'storage']) ?? 'Information unavailable',
        culinaryUses: findVal(['culinaryUses', 'culinary uses']) ?? 'Information unavailable',
      ),
    );
  }
}

class AllergyInfo {
  final String citrusAllergy;
  final String crossReactivity;
  final String sensitivityAdvice;

  const AllergyInfo({
    required this.citrusAllergy,
    required this.crossReactivity,
    required this.sensitivityAdvice,
  });

  factory AllergyInfo.fromJson(Map<String, dynamic> json) {
    return AllergyInfo(
      citrusAllergy: json['citrusAllergy']?.toString() ?? 'Information unavailable',
      crossReactivity: json['crossReactivity']?.toString() ?? 'Information unavailable',
      sensitivityAdvice: json['sensitivityAdvice']?.toString() ?? 'Information unavailable',
    );
  }
}

class HealthInfo {
  final String benefits;
  final String storageRecommendation;
  final String culinaryUses;

  const HealthInfo({
    required this.benefits,
    required this.storageRecommendation,
    required this.culinaryUses,
  });

  factory HealthInfo.fromJson(Map<String, dynamic> json) {
    return HealthInfo(
      benefits: json['benefits']?.toString() ?? 'Information unavailable',
      storageRecommendation: json['storageRecommendation']?.toString() ?? 'Information unavailable',
      culinaryUses: json['culinaryUses']?.toString() ?? 'Information unavailable',
    );
  }
}

