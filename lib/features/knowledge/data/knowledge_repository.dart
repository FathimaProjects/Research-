import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/citrus_knowledge_model.dart';

class KnowledgeRepository {
  Map<String, CitrusKnowledge>? _cache;

  Future<void> _loadDatabase() async {
    if (_cache != null) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/citrus_knowledge.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      _cache = {};
      data.forEach((fruitKey, fruitData) {
        _cache![fruitKey] = CitrusKnowledge.fromJson(
          fruitKey,
          fruitData as Map<String, dynamic>,
        );
      });
    } catch (e) {
      _cache = {};
    }
  }

  Future<CitrusKnowledge?> getFruitKnowledge(String fruitName) async {
    await _loadDatabase();
    return _cache?[fruitName];
  }
}

