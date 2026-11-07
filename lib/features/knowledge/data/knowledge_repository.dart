import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/network_service.dart';
import '../domain/citrus_knowledge_model.dart';

class KnowledgeRepository {
  final Map<String, CitrusKnowledge> _cache = {};

  /// Fetches verified fruit knowledge from the live cloud database (Firebase Firestore).
  /// Project: citrus-data-46a79 (Citrus Data)
  /// Collection: 'Citrus'
  /// Exact Document IDs: 'Kaffir Lime', 'Lemon', 'Lime', 'Orange', 'Tangerine'
  ///
  /// Uses Cloud Firestore Flutter SDK with Anonymous Authentication.
  /// When offline or if no remote record is found, returns null so the UI
  /// cleanly displays "Information unavailable".
  Future<CitrusKnowledge?> getFruitKnowledge(String fruitName) async {
    final bool isOnline = await NetworkService.isConnected();
    if (!isOnline) {
      debugPrint('KnowledgeRepository: Device is offline. Remote knowledge unavailable.');
      return null;
    }

    if (_cache.containsKey(fruitName)) {
      return _cache[fruitName];
    }

    try {
      // Complete anonymous authentication before accessing Firestore
      await AuthService().ensureAuthenticated();

      // Retrieve exact document from Citrus collection using predicted label as doc ID
      final doc = await FirebaseFirestore.instance
          .collection('Citrus')
          .doc(fruitName)
          .get()
          .timeout(const Duration(seconds: 8));

      if (doc.exists && doc.data() != null) {
        debugPrint('KnowledgeRepository: Retrieved document for "$fruitName": ${doc.data()}');
        final knowledge = CitrusKnowledge.fromJson(fruitName, doc.data()!);
        _cache[fruitName] = knowledge;
        return knowledge;
      } else {
        debugPrint('KnowledgeRepository: Document "$fruitName" does not exist in collection "Citrus".');
      }
    } on FirebaseException catch (e) {
      debugPrint('KnowledgeRepository: Firestore error [${e.code}]: ${e.message}');
    } on TimeoutException catch (e) {
      debugPrint('KnowledgeRepository: Firestore request timed out: $e');
    } catch (e) {
      debugPrint('KnowledgeRepository: Unexpected error retrieving "$fruitName": $e');
    }

    return null;
  }
}

