import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contribution_repository.dart';
import '../../data/models/contribution_model.dart';
import '../../data/services/streak_service.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../../missions/data/repositories/mission_repository.dart';
import '../../../rewards/data/models/badge_model.dart';
import '../../../rewards/data/models/xp_event.dart';
import '../../../rewards/data/services/badge_service.dart';
import '../../../rewards/data/services/xp_service.dart';
import '../../../../repositories/user_repository.dart';

// ---------------------------------------------------------------------------
// Existing stream providers
// ---------------------------------------------------------------------------

final missionContributionsProvider = StreamProvider.family<
    List<ContributionModel>,
    ({String missionId, String userId})>((ref, params) {
  return ref
      .watch(contributionRepositoryProvider)
      .watchContributions(params.missionId, userId: params.userId);
});

final todayContributionsProvider =
    StreamProvider<List<ContributionModel>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref
      .watch(contributionRepositoryProvider)
      .watchTodayContributions(userId);
});

// ---------------------------------------------------------------------------
// ContributionResult
// ---------------------------------------------------------------------------

/// Result of a full contribution flow, including streak info and new badges.
class ContributionResult {
  final String contributionId;
  final StreakResult streakResult;
  final List<BadgeModel> newBadges;
  final bool missionCompleted;

  const ContributionResult({
    required this.contributionId,
    required this.streakResult,
    required this.newBadges,
    required this.missionCompleted,
  });
}

// ---------------------------------------------------------------------------
// ContributionFlowNotifier
// ---------------------------------------------------------------------------

class ContributionFlowNotifier extends StateNotifier<AsyncValue<ContributionResult?>> {
  final ContributionRepository _contributionRepo;
  final MissionRepository _missionRepo;
  final UserRepository _userRepo;
  final StreakService _streakService;
  final BadgeService _badgeService;
  final XpService _xpService;

  ContributionFlowNotifier({
    required ContributionRepository contributionRepo,
    required MissionRepository missionRepo,
    required UserRepository userRepo,
    required StreakService streakService,
    required BadgeService badgeService,
    required XpService xpService,
  })  : _contributionRepo = contributionRepo,
        _missionRepo = missionRepo,
        _userRepo = userRepo,
        _streakService = streakService,
        _badgeService = badgeService,
        _xpService = xpService,
        super(const AsyncValue.data(null));

  /// Orchestrates the full contribution flow:
  /// 1. Add contribution to Firestore
  /// 2. Update mission savedAmount
  /// 3. Process streak (via StreakService)
  /// 4. Check & award badges (via BadgeService)
  /// 5. Check if mission is now complete (savedAmount >= targetAmount)
  /// 6. Return result with any new badges for UI celebration
  Future<ContributionResult?> logContribution({
    required String missionId,
    required String userId,
    required double amount,
    String? note,
  }) async {
    state = const AsyncValue.loading();

    try {
      final now = DateTime.now();

      // 1. Add contribution to Firestore
      final contribution = ContributionModel(
        id: '',
        missionId: missionId,
        userId: userId,
        amount: amount,
        date: now,
        note: note,
        createdAt: now,
      );

      final contributionId =
          await _contributionRepo.addContribution(contribution);

      // 2. Update mission savedAmount atomically
      final mission = await _missionRepo.getMission(missionId);
      if (mission == null) {
        throw Exception('Mission not found: $missionId');
      }

      final newSavedAmount = mission.savedAmount + amount;
      final missionUpdate = <String, dynamic>{
        'savedAmount': newSavedAmount,
      };

      // 5. Check if mission is now complete
      bool missionCompleted = false;
      if (newSavedAmount >= mission.targetAmount &&
          mission.status == 'active') {
        missionCompleted = true;
        missionUpdate['status'] = 'completed';
        missionUpdate['completedAt'] = Timestamp.fromDate(now);
      }

      await _missionRepo.updateMission(missionId, missionUpdate);

      // Update user totalSaved
      final user = await _userRepo.getUser(userId);
      if (user != null) {
        final updateData = <String, dynamic>{
          'totalSaved': user.totalSaved + amount,
        };
        if (missionCompleted) {
          updateData['totalMissionsCompleted'] =
              user.totalMissionsCompleted + 1;
        }
        await _userRepo.updateUser(userId, updateData);
      }

      // 3. Process streak
      final streakResult = await _streakService.processContribution(
        missionId: missionId,
        userId: userId,
        contributionDate: now,
      );

      // 4. Check & award badges
      // Re-fetch mission to get updated state (savedAmount, status, streak)
      final updatedMission = await _missionRepo.getMission(missionId);
      final newBadges = await _badgeService.checkAndAwardBadges(
        userId: userId,
        missionId: missionId,
        mission: updatedMission ?? mission,
        currentStreak: streakResult.newStreak,
      );

      // 5. Award XP
      await _xpService.awardXp(userId, XpEventType.dailyContribution,
          missionId: missionId);

      // Award XP for checkpoint milestones
      final progress = mission.targetAmount > 0
          ? (newSavedAmount / mission.targetAmount).clamp(0.0, 1.0)
          : 0.0;
      final oldProgress = mission.targetAmount > 0
          ? (mission.savedAmount / mission.targetAmount).clamp(0.0, 1.0)
          : 0.0;
      for (final checkpoint in [0.25, 0.50, 0.75]) {
        if (oldProgress < checkpoint && progress >= checkpoint) {
          await _xpService.awardXp(userId, XpEventType.checkpointReached,
              missionId: missionId);
        }
      }

      // Award XP for streak milestones
      final oldStreak = mission.currentStreak;
      final newStreak = streakResult.newStreak;
      if (oldStreak < 7 && newStreak >= 7) {
        await _xpService.awardXp(userId, XpEventType.streak7,
            missionId: missionId);
      }
      if (oldStreak < 30 && newStreak >= 30) {
        await _xpService.awardXp(userId, XpEventType.streak30,
            missionId: missionId);
      }
      if (oldStreak < 60 && newStreak >= 60) {
        await _xpService.awardXp(userId, XpEventType.streak60,
            missionId: missionId);
      }

      // Award XP for mission completion
      if (missionCompleted) {
        await _xpService.awardXp(userId, XpEventType.missionCompleted,
            missionId: missionId);
        // Check speed runner (completed before deadline)
        if (updatedMission != null &&
            updatedMission.completedAt != null &&
            updatedMission.completedAt!.isBefore(updatedMission.endDate)) {
          await _xpService.awardXp(userId, XpEventType.speedRunner,
              missionId: missionId);
        }
      }

      // 6. Return result
      final result = ContributionResult(
        contributionId: contributionId,
        streakResult: streakResult,
        newBadges: newBadges,
        missionCompleted: missionCompleted,
      );

      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Reset state after the UI has consumed the result (e.g. after showing
  /// celebration dialogs).
  void clearResult() {
    state = const AsyncValue.data(null);
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

final contributionFlowProvider = StateNotifierProvider<
    ContributionFlowNotifier, AsyncValue<ContributionResult?>>((ref) {
  return ContributionFlowNotifier(
    contributionRepo: ref.watch(contributionRepositoryProvider),
    missionRepo: ref.watch(missionRepositoryProvider),
    userRepo: ref.watch(userRepositoryProvider),
    streakService: ref.watch(streakServiceProvider),
    badgeService: ref.watch(badgeServiceProvider),
    xpService: ref.watch(xpServiceProvider),
  );
});
