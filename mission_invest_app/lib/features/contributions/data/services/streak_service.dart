import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/collection_paths.dart';
import '../../../../repositories/user_repository.dart';
import '../../../missions/data/models/mission_model.dart';
import '../../../missions/data/repositories/mission_repository.dart';

// ---------------------------------------------------------------------------
// StreakResult Model
// ---------------------------------------------------------------------------

class StreakResult {
  final int newStreak;
  final bool recoveryUsed;
  final bool streakBroken;
  final int globalStreak;

  const StreakResult({
    required this.newStreak,
    required this.recoveryUsed,
    required this.streakBroken,
    required this.globalStreak,
  });
}

// ---------------------------------------------------------------------------
// StreakService
// ---------------------------------------------------------------------------

class StreakService {
  final MissionRepository _missionRepository;
  final UserRepository _userRepository;
  final FirebaseFirestore _firestore;

  StreakService({
    required MissionRepository missionRepository,
    required UserRepository userRepository,
    FirebaseFirestore? firestore,
  })  : _missionRepository = missionRepository,
        _userRepository = userRepository,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Called after a contribution is logged. Processes streak logic and updates
  /// both the mission streak fields and the user's global streak.
  Future<StreakResult> processContribution({
    required String missionId,
    required String userId,
    required DateTime contributionDate,
  }) async {
    // 1. Get mission from Firestore
    final mission = await _missionRepository.getMission(missionId);
    if (mission == null) {
      throw Exception('Mission not found: $missionId');
    }

    final today = _normalizeDate(contributionDate);
    final lastDate = mission.lastContributionDate;
    final lastNormalized = lastDate != null ? _normalizeDate(lastDate) : null;

    int newStreak = mission.currentStreak;
    bool recoveryUsed = false;
    bool streakBroken = false;

    if (lastNormalized != null) {
      final daysDiff = today.difference(lastNormalized).inDays;

      if (daysDiff == 0) {
        // 2. Same day contribution -- no streak change
        // Just update lastContributionDate in case time changed
      } else if (daysDiff == 1) {
        // 3. Consecutive day -- increment streak
        newStreak = mission.currentStreak + 1;
      } else if (daysDiff == 2 && canRecover(mission)) {
        // 4. Missed exactly 1 day -- check recovery eligibility
        newStreak = mission.currentStreak + 1;
        recoveryUsed = true;
      } else {
        // 5. Missed too many days -- streak broken, reset to 1
        newStreak = 1;
        streakBroken = true;
      }
    } else {
      // First contribution ever
      newStreak = 1;
    }

    final newLongestStreak =
        newStreak > mission.longestStreak ? newStreak : mission.longestStreak;

    // 6. Build mission update data
    final missionUpdate = <String, dynamic>{
      'currentStreak': newStreak,
      'longestStreak': newLongestStreak,
      'lastContributionDate': Timestamp.fromDate(contributionDate),
    };

    // If recovery was used, record it so it can't be used again this week
    if (recoveryUsed) {
      missionUpdate['recoveryUsedThisWeek'] = true;
      missionUpdate['recoveryWeekStart'] =
          Timestamp.fromDate(_startOfWeek(today));

      // Also record in the streakRecoveries subcollection for audit
      await _firestore
          .collection(CollectionPaths.users)
          .doc(userId)
          .collection(CollectionPaths.streakRecoveries)
          .add({
        'missionId': missionId,
        'recoveredAt': Timestamp.fromDate(contributionDate),
        'missedDate': Timestamp.fromDate(today.subtract(const Duration(days: 1))),
      });
    }

    // 7. Update mission streak fields
    await _missionRepository.updateMission(missionId, missionUpdate);

    // 8. Update user global streak
    final globalStreak =
        await _updateGlobalStreak(userId, contributionDate, streakBroken);

    return StreakResult(
      newStreak: newStreak,
      recoveryUsed: recoveryUsed,
      streakBroken: streakBroken,
      globalStreak: globalStreak,
    );
  }

  /// Check if streak recovery is available for the given mission.
  /// Recovery is allowed max 1 time per 7 days, and only when exactly 1 day
  /// was missed.
  bool canRecover(MissionModel mission) {
    if (!mission.recoveryUsedThisWeek) return true;

    // Check if 7 days have passed since recovery week start
    final weekStart = mission.recoveryWeekStart;
    if (weekStart == null) return true;

    final now = DateTime.now();
    final daysSinceWeekStart = now.difference(weekStart).inDays;
    return daysSinceWeekStart >= 7;
  }

  /// Apply streak recovery for a mission where the user missed exactly 1 day.
  /// This is called explicitly when the user chooses to use their recovery.
  Future<void> applyRecovery(String missionId) async {
    final mission = await _missionRepository.getMission(missionId);
    if (mission == null) {
      throw Exception('Mission not found: $missionId');
    }

    if (!canRecover(mission)) {
      throw Exception('Recovery not available for this mission');
    }

    final now = DateTime.now();
    await _missionRepository.updateMission(missionId, {
      'currentStreak': mission.currentStreak + 1,
      'recoveryUsedThisWeek': true,
      'recoveryWeekStart': Timestamp.fromDate(_startOfWeek(now)),
    });

    await _firestore
        .collection(CollectionPaths.users)
        .doc(mission.userId)
        .collection(CollectionPaths.streakRecoveries)
        .add({
      'missionId': missionId,
      'recoveredAt': Timestamp.fromDate(now),
      'missedDate': Timestamp.fromDate(now.subtract(const Duration(days: 1))),
    });
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Updates the user's global streak (across all missions).
  /// Returns the new global streak value.
  Future<int> _updateGlobalStreak(
    String userId,
    DateTime contributionDate,
    bool anyStreakBroken,
  ) async {
    final user = await _userRepository.getUser(userId);
    if (user == null) return 0;

    final lastActive = user.lastActiveAt;
    final today = _normalizeDate(contributionDate);

    int newGlobalStreak = user.currentGlobalStreak;

    if (lastActive != null) {
      final lastNormalized = _normalizeDate(lastActive);
      final daysDiff = today.difference(lastNormalized).inDays;

      if (daysDiff == 0) {
        // Same day -- no global streak change
      } else if (daysDiff == 1) {
        newGlobalStreak += 1;
      } else {
        // Missed days globally -- reset
        newGlobalStreak = 1;
      }
    } else {
      newGlobalStreak = 1;
    }

    final newLongestGlobal = newGlobalStreak > user.longestGlobalStreak
        ? newGlobalStreak
        : user.longestGlobalStreak;

    await _userRepository.updateUser(userId, {
      'currentGlobalStreak': newGlobalStreak,
      'longestGlobalStreak': newLongestGlobal,
      'lastActiveAt': Timestamp.fromDate(contributionDate),
    });

    return newGlobalStreak;
  }

  /// Normalize a DateTime to midnight (date only, no time component).
  DateTime _normalizeDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  /// Get the start of the ISO week (Monday) for the given date.
  DateTime _startOfWeek(DateTime dt) {
    final normalized = _normalizeDate(dt);
    final weekday = normalized.weekday; // Monday = 1
    return normalized.subtract(Duration(days: weekday - 1));
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

final streakServiceProvider = Provider<StreakService>((ref) {
  return StreakService(
    missionRepository: ref.watch(missionRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
});
