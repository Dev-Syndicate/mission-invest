import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/collection_paths.dart';
// MissionModel is received as a parameter, not imported from repository.
import '../../../missions/data/models/mission_model.dart';
import '../models/badge_model.dart';
import '../repositories/badge_repository.dart';

// ---------------------------------------------------------------------------
// BadgeService
// ---------------------------------------------------------------------------

class BadgeService {
  final BadgeRepository _badgeRepository;
  final FirebaseFirestore _firestore;

  BadgeService({
    required BadgeRepository badgeRepository,
    FirebaseFirestore? firestore,
  })  : _badgeRepository = badgeRepository,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Check all badge conditions after a contribution and award any newly
  /// earned badges. Returns the list of badges that were just awarded
  /// (useful for showing celebration toasts/animations in the UI).
  Future<List<BadgeModel>> checkAndAwardBadges({
    required String userId,
    required String missionId,
    required MissionModel mission,
    required int currentStreak,
  }) async {
    final List<BadgeModel> newBadges = [];
    final now = DateTime.now();

    // -- Streak badges --

    if (currentStreak >= 3) {
      final badge = await _tryAward(
        userId: userId,
        missionId: missionId,
        missionTitle: mission.title,
        badgeType: '3_day_streak',
        earnedAt: now,
      );
      if (badge != null) newBadges.add(badge);
    }

    if (currentStreak >= 7) {
      final badge = await _tryAward(
        userId: userId,
        missionId: missionId,
        missionTitle: mission.title,
        badgeType: '7_day_warrior',
        earnedAt: now,
      );
      if (badge != null) newBadges.add(badge);
    }

    if (currentStreak >= 30) {
      final badge = await _tryAward(
        userId: userId,
        missionId: missionId,
        missionTitle: mission.title,
        badgeType: '30_day_survivor',
        earnedAt: now,
      );
      if (badge != null) newBadges.add(badge);
    }

    // -- Progress badges --

    if (mission.progressPercentage >= 0.5) {
      final badge = await _tryAward(
        userId: userId,
        missionId: missionId,
        missionTitle: mission.title,
        badgeType: 'halfway_hero',
        earnedAt: now,
      );
      if (badge != null) newBadges.add(badge);
    }

    // -- Completion badges --

    if (mission.status == 'completed') {
      // first_complete: only if user has 0 previously completed missions
      final completedCount = await _getCompletedMissionCount(userId);
      // Count includes the current one, so check <= 1
      if (completedCount <= 1) {
        final badge = await _tryAward(
          userId: userId,
          missionId: missionId,
          missionTitle: mission.title,
          badgeType: 'first_complete',
          earnedAt: now,
        );
        if (badge != null) newBadges.add(badge);
      }

      // speed_runner: mission completed before the endDate
      if (now.isBefore(mission.endDate)) {
        final badge = await _tryAward(
          userId: userId,
          missionId: missionId,
          missionTitle: mission.title,
          badgeType: 'speed_runner',
          earnedAt: now,
        );
        if (badge != null) newBadges.add(badge);
      }
    }

    return newBadges;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Attempts to award a badge. Returns the badge model if newly awarded,
  /// or null if the user already has this badge for this mission.
  Future<BadgeModel?> _tryAward({
    required String userId,
    required String missionId,
    required String missionTitle,
    required String badgeType,
    required DateTime earnedAt,
  }) async {
    // Check if already has this specific badge for this mission
    final existing = await _firestore
        .collection(CollectionPaths.badges)
        .where('userId', isEqualTo: userId)
        .where('badgeType', isEqualTo: badgeType)
        .where('missionId', isEqualTo: missionId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) return null;

    final badge = BadgeModel(
      id: '', // Will be assigned by Firestore
      userId: userId,
      badgeType: badgeType,
      missionId: missionId,
      missionTitle: missionTitle,
      earnedAt: earnedAt,
    );

    await _badgeRepository.awardBadge(badge);
    return badge;
  }

  /// Returns the number of completed missions for a user.
  Future<int> _getCompletedMissionCount(String userId) async {
    final snap = await _firestore
        .collection(CollectionPaths.missions)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'completed')
        .count()
        .get();
    return snap.count ?? 0;
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

final badgeServiceProvider = Provider<BadgeService>((ref) {
  return BadgeService(
    badgeRepository: ref.watch(badgeRepositoryProvider),
  );
});
