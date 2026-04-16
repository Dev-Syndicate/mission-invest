import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/collection_paths.dart';
import '../models/contribution_model.dart';

class ContributionRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(CollectionPaths.contributions);

  Stream<List<ContributionModel>> watchContributions(
    String missionId, {
    required String userId,
  }) {
    return _collection
        .where('missionId', isEqualTo: missionId)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                ContributionModel.fromJson(_fromFirestore(doc.data(), doc.id)))
            .toList());
  }

  Stream<List<ContributionModel>> watchTodayContributions(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _collection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                ContributionModel.fromJson(_fromFirestore(doc.data(), doc.id)))
            .toList());
  }

  Future<String> addContribution(ContributionModel contribution) async {
    final data = _toFirestore(contribution.toJson());
    final docRef = await _collection.add(data);
    return docRef.id;
  }

  Future<List<ContributionModel>> getContributionsForDateRange(
    String missionId,
    DateTime start,
    DateTime end,
  ) async {
    final snap = await _collection
        .where('missionId', isEqualTo: missionId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .get();

    return snap.docs
        .map(
            (doc) => ContributionModel.fromJson(_fromFirestore(doc.data(), doc.id)))
        .toList();
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
        if (dt != null &&
            (key.endsWith('At') ||
                key.endsWith('Date') ||
                key == 'date' ||
                key == 'createdAt')) {
          data[key] = Timestamp.fromDate(dt);
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final contributionRepositoryProvider = Provider<ContributionRepository>((ref) {
  return ContributionRepository();
});

final watchContributionsProvider = StreamProvider.family<
    List<ContributionModel>,
    ({String missionId, String userId})>((ref, params) {
  return ref
      .watch(contributionRepositoryProvider)
      .watchContributions(params.missionId, userId: params.userId);
});

final todayContributionsProvider =
    StreamProvider.family<List<ContributionModel>, String>((ref, userId) {
  return ref
      .watch(contributionRepositoryProvider)
      .watchTodayContributions(userId);
});
