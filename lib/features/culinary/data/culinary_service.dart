import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../domain/recipe_item.dart';

class CulinaryService {
  // Configurable backend URL for deployed Firebase Cloud Function
  static const String backendUrl = ''; 

  /// Fetches culinary ideas for the identified citrus fruit
  Future<List<RecipeItem>> getCulinaryIdeas(String fruitName) async {
    // If backend URL is provided, call backend proxy securely
    if (backendUrl.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(backendUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'fruit': fruitName}),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['suggestions'] is List) {
            final list = (data['suggestions'] as List)
                .map((item) => RecipeItem.fromJson(item as Map<String, dynamic>))
                .toList();
            if (list.isNotEmpty) return list;
          }
        }
      } catch (e) {
        debugPrint('Backend call failed, falling back to verified catalogue: $e');
      }
    }

    // Default & offline fallback: Load verified curated catalogue
    return _loadVerifiedCatalogue(fruitName);
  }

  Future<List<RecipeItem>> _loadVerifiedCatalogue(String fruitName) async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/citrus_culinary.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      if (data.containsKey(fruitName) && data[fruitName] is List) {
        return (data[fruitName] as List)
            .map((item) => RecipeItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading verified recipes catalogue: $e');
    }

    return [];
  }
}

