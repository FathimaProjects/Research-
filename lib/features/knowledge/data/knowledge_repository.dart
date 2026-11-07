import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/network_service.dart';
import '../domain/citrus_knowledge_model.dart';

class KnowledgeRepository {
  final Map<String, CitrusKnowledge> _cache = {};

  /// Fetches verified fruit knowledge from the live cloud database (Firebase Firestore).
  /// Project: citrus-data-46a79 (Citrus Data)
  /// Collection: 'Citrus'
  /// Documents: Orange, Tangerine, Lemon, Lime, Kaffir Lime
  ///
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

    try {
      var doc = await FirebaseFirestore.instance
          .collection('Citrus')
          .doc(fruitName)
          .get()
          .timeout(const Duration(seconds: 8));

      if (!doc.exists) {
        // Fallback if document ID was created in lowercase
        doc = await FirebaseFirestore.instance
            .collection('Citrus')
            .doc(fruitName.toLowerCase())
            .get()
            .timeout(const Duration(seconds: 5));
      }

      if (doc.exists && doc.data() != null) {
        debugPrint('KnowledgeRepository: Successfully fetched Firestore document for $fruitName: ${doc.data()}');
        final knowledge = CitrusKnowledge.fromJson(fruitName, doc.data()!);
        _cache[fruitName] = knowledge;
        return knowledge;
      } else {
        debugPrint('KnowledgeRepository: Document $fruitName not found in collection "Citrus".');
      }
    } catch (e) {
      debugPrint('KnowledgeRepository: Firestore fetch notice ($e)');
    }

    return null;
  }
}

