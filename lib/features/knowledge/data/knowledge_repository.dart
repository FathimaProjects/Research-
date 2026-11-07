import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/network_service.dart';
import '../domain/citrus_knowledge_model.dart';

class KnowledgeRepository {
  // Configurable Firebase Realtime Database / Cloud Firestore REST endpoint
  // Example: 'https://citrus-ai-default-rtdb.firebaseio.com'
  static const String firebaseUrl = '';

  final Map<String, CitrusKnowledge> _cache = {};

  /// Fetches verified fruit knowledge from the live cloud database.
  /// When offline or if no remote record is found, returns null so the UI
  /// cleanly displays "Information unavailable".
  Future<CitrusKnowledge?> getFruitKnowledge(String fruitName) async {
    final bool isOnline = await NetworkService.isConnected();
    if (!isOnline) {
      debugPrint('KnowledgeRepository: Device is offline. Knowledge unavailable.');
      return null;
    }

    if (_cache.containsKey(fruitName)) {
      return _cache[fruitName];
    }

    if (firebaseUrl.isNotEmpty) {
      try {
        final response = await http
            .get(
              Uri.parse('$firebaseUrl/citrus_knowledge/$fruitName.json'),
            )
            .timeout(const Duration(seconds: 8));

        if (response.statusCode == 200 && response.body.isNotEmpty && response.body != 'null') {
          final data = json.decode(response.body);
          if (data is Map<String, dynamic>) {
            final knowledge = CitrusKnowledge.fromJson(fruitName, data);
            _cache[fruitName] = knowledge;
            return knowledge;
          }
        }
      } catch (e) {
        debugPrint('KnowledgeRepository: Error querying Firebase: $e');
      }
    }

    return null;
  }
}

