import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/season_model.dart';

class SeasonRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('seasons');

  /// Watches all currently active seasons.
  Stream<List<SeasonModel>> watchActiveSeasons() {
    return _collection
        .where('isActive', isEqualTo: true)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                SeasonModel.fromJson(_fromFirestore(doc.data(), doc.id)))
            .toList());
  }

  /// Fetches a single season by ID.
  Future<SeasonModel?> getSeason(String seasonId) async {
    final snap = await _collection.doc(seasonId).get();
    if (!snap.exists || snap.data() == null) return null;
    return SeasonModel.fromJson(_fromFirestore(snap.data()!, snap.id));
  }

  /// Joins a season: increments participant count and sets mission.seasonId.
  Future<void> joinSeason(
    String userId,
    String seasonId,
    String missionId,
  ) async {
    final batch = _firestore.batch();

    // Increment participant count on the season doc.
    batch.update(_collection.doc(seasonId), {
      'participantCount': FieldValue.increment(1),
    });

    // Link the mission to the season.
    batch.update(_firestore.collection('missions').doc(missionId), {
      'seasonId': seasonId,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Watches the user's rank (as a percentile position) within a season.
  /// Returns the "Top X%" value (e.g. 15 means "Top 15%").
  Stream<int> watchUserRankInSeason(String userId, String seasonId) {
    // We watch all missions linked to this season, ranked by progress.
    return _firestore
        .collection('missions')
        .where('seasonId', isEqualTo: seasonId)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return 100;

      // Build a list of (userId, progress%) sorted descending.
      final entries = snap.docs.map((doc) {
        final data = doc.data();
        final saved = (data['savedAmount'] as num?)?.toDouble() ?? 0.0;
        final target = (data['targetAmount'] as num?)?.toDouble() ?? 1.0;
        final progress = target > 0 ? (saved / target) : 0.0;
        return _RankEntry(
          userId: data['userId'] as String? ?? '',
          progress: progress,
        );
      }).toList()
        ..sort((a, b) => b.progress.compareTo(a.progress));

      // Find user's position.
      final userIndex =
          entries.indexWhere((e) => e.userId == userId);
      if (userIndex < 0) return 100; // user not found in season

      final rank = ((userIndex + 1) / entries.length * 100).ceil();
      return rank.clamp(1, 100);
    });
  }

  // ---------------------------------------------------------------------------
  // Firestore helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data, String id) {
    final json = Map<String, dynamic>.from(data);
    json['id'] = id;
    _convertTimestamps(json);
    return json;
  }

  void _convertTimestamps(Map<String, dynamic> json) {
    for (final key in json.keys) {
      if (json[key] is Timestamp) {
        json[key] = (json[key] as Timestamp).toDate().toIso8601String();
      }
    }
  }
}

class _RankEntry {
  final String userId;
  final double progress;
  _RankEntry({required this.userId, required this.progress});
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final seasonRepositoryProvider = Provider<SeasonRepository>((ref) {
  return SeasonRepository();
});

final activeSeasonsProvider = StreamProvider<List<SeasonModel>>((ref) {
  return ref.watch(seasonRepositoryProvider).watchActiveSeasons();
});

final seasonProvider =
    FutureProvider.family<SeasonModel?, String>((ref, seasonId) {
  return ref.watch(seasonRepositoryProvider).getSeason(seasonId);
});

final userSeasonRankProvider =
    StreamProvider.family<int, ({String userId, String seasonId})>((ref, args) {
  return ref
      .watch(seasonRepositoryProvider)
      .watchUserRankInSeason(args.userId, args.seasonId);
});
