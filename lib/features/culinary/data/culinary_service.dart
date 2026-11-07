import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/network_service.dart';
import '../domain/recipe_item.dart';

class CulinaryService {
  // Configurable backend URL for deployed Firebase Cloud Function (Gemini Proxy)
  // Example: 'https://us-central1-<project-id>.cloudfunctions.net/getCulinarySuggestions'
  static const String backendUrl = ''; 

  /// Fetches culinary ideas for the identified citrus fruit from the live cloud backend.
  /// When offline or if no remote suggestions are returned, returns an empty list
  /// so the UI cleanly displays the "Information unavailable" state.
  Future<List<RecipeItem>> getCulinaryIdeas(String fruitName) async {
    final bool isOnline = await NetworkService.isConnected();
    if (!isOnline) {
      debugPrint('CulinaryService: Device is offline. Returning empty list.');
      return [];
    }

    if (backendUrl.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse(backendUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'fruit': fruitName}),
        ).timeout(const Duration(seconds: 10));

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
        debugPrint('CulinaryService: Error querying cloud backend: $e');
      }
    }

    return [];
  }
}

