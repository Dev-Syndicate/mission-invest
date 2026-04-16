import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/collection_paths.dart';
import '../models/badge_model.dart';

class BadgeRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(CollectionPaths.badges);

  Stream<List<BadgeModel>> watchUserBadges(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('earnedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                BadgeModel.fromJson(_fromFirestore(doc.data(), doc.id)))
            .toList());
  }

  Future<List<BadgeModel>> getUserBadges(String userId) async {
    final snap = await _collection
        .where('userId', isEqualTo: userId)
        .orderBy('earnedAt', descending: true)
        .get();

    return snap.docs
        .map((doc) => BadgeModel.fromJson(_fromFirestore(doc.data(), doc.id)))
        .toList();
  }

  /// Awards a badge. Checks for duplicates (same userId + badgeType + missionId)
  /// to avoid awarding the same badge twice for the same mission.
  Future<void> awardBadge(BadgeModel badge) async {
    final existing = await _collection
        .where('userId', isEqualTo: badge.userId)
        .where('badgeType', isEqualTo: badge.badgeType)
        .where('missionId', isEqualTo: badge.missionId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) return; // already awarded

    final data = _toFirestore(badge.toJson());
    await _collection.add(data);
  }

  Future<bool> hasBadge(String userId, String badgeType) async {
    final snap = await _collection
        .where('userId', isEqualTo: userId)
        .where('badgeType', isEqualTo: badgeType)
        .limit(1)
        .get();

    return snap.docs.isNotEmpty;
  }

  // ---------------------------------------------------------------------------
  // Firestore ↔ JSON helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data, String id) {
    final json = Map<String, dynamic>.from(data);
    json['id'] = id;
    _convertTimestamps(json);
    return json;
  }

  Map<String, dynamic> _toFirestore(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    data.remove('id');
    _convertDateTimesToTimestamps(data);
    return data;
  }

  void _convertTimestamps(Map<String, dynamic> json) {
    for (final key in json.keys) {
      if (json[key] is Timestamp) {
        json[key] = (json[key] as Timestamp).toDate().toIso8601String();
      }
    }
  }

  void _convertDateTimesToTimestamps(Map<String, dynamic> data) {
    for (final key in data.keys) {
      final value = data[key];
      if (value is String) {
        final dt = DateTime.tryParse(value);
        if (dt != null && (key.endsWith('At') || key == 'earnedAt')) {
          data[key] = Timestamp.fromDate(dt);
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final badgeRepositoryProvider = Provider<BadgeRepository>((ref) {
  return BadgeRepository();
});

final watchUserBadgesProvider =
    StreamProvider.family<List<BadgeModel>, String>((ref, userId) {
  return ref.watch(badgeRepositoryProvider).watchUserBadges(userId);
});
