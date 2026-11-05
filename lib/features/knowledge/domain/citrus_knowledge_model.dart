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

  factory CitrusKnowledge.fromJson(String fruit, Map<String, dynamic> json) {
    final rawNutrition = json['nutrition'] as Map<String, dynamic>? ?? {};
    final nutritionMap = rawNutrition.map((k, v) => MapEntry(k, v.toString()));

    return CitrusKnowledge(
      fruitName: fruit,
      scientificName: json['scientificName']?.toString() ?? 'Information unavailable',
      commonName: json['commonName']?.toString() ?? 'Information unavailable',
      servingSize: json['servingSize']?.toString() ?? 'Information unavailable',
      nutrition: nutritionMap,
      allergyInfo: AllergyInfo.fromJson(json['allergyInfo'] as Map<String, dynamic>? ?? {}),
      healthInfo: HealthInfo.fromJson(json['healthInfo'] as Map<String, dynamic>? ?? {}),
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

