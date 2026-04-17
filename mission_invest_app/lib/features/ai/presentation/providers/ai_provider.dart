import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/repositories/ai_repository.dart';
import '../../data/models/nudge_response.dart';
import '../../data/models/prediction_response.dart';
import '../../data/models/adapt_response.dart';
import '../../data/models/motivation_response.dart';
import '../../../missions/data/models/mission_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(ref.read(apiClientProvider));
});

// ── Nudge for a specific mission (fetched on demand) ──

final missionNudgeProvider =
    FutureProvider.family<NudgeResponse?, MissionModel>((ref, mission) async {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null || !mission.isActive) return null;

  final repo = ref.read(aiRepositoryProvider);
  final trigger = mission.missedDays > 0 ? 'missed_day' : 'manual_request';

  return repo.getNudge(
    userId: uid,
    missionId: mission.id,
    missionTitle: mission.title,
    trigger: trigger,
    currentStreak: mission.currentStreak,
    missedDays: mission.missedDays,
    daysLeft: mission.daysRemaining,
    amountLeft: mission.amountRemaining,
    targetAmount: mission.targetAmount,
    completionProbability: mission.completionProbability,
  );
});

// ── Prediction for a specific mission ──

final missionPredictionProvider =
    FutureProvider.family<PredictionResponse?, MissionModel>(
        (ref, mission) async {
  if (!mission.isActive) return null;

  final repo = ref.read(aiRepositoryProvider);
  final streakRatio = mission.durationDays > 0
      ? mission.currentStreak / mission.durationDays
      : 0.0;
  final amountRatio = mission.targetAmount > 0
      ? mission.savedAmount / mission.targetAmount
      : 0.0;
  final dayRatio = mission.durationDays > 0
      ? mission.daysElapsed / mission.durationDays
      : 0.0;

  return repo.getPrediction(
    missionId: mission.id,
    streakRatio: streakRatio,
    amountRatio: amountRatio,
    dayRatio: dayRatio,
    missedDays: mission.missedDays,
    totalDays: mission.durationDays,
  );
});

// ── Adaptation suggestion for a specific mission ──

final missionAdaptProvider =
    FutureProvider.family<AdaptResponse?, MissionModel>((ref, mission) async {
  if (!mission.isActive) return null;

  final repo = ref.read(aiRepositoryProvider);
  return repo.getAdaptation(
    missionId: mission.id,
    missionTitle: mission.title,
    currentSaved: mission.savedAmount,
    daysLeft: mission.daysRemaining,
    targetAmount: mission.targetAmount,
    dailyTarget: mission.dailyTarget,
    currentStreak: mission.currentStreak,
  );
});

// ── Daily motivation for home page (picks the most struggling mission) ──

final dailyMotivationProvider =
    FutureProvider<MotivationResponse?>((ref) async {
  final uid = ref.watch(currentUserIdProvider);
  final missionsAsync = ref.watch(homeActiveMissionsProvider);
  final missions = missionsAsync.valueOrNull;

  if (uid == null || missions == null || missions.isEmpty) return null;

  // Pick the mission with most missed days or lowest progress
  final target = missions.reduce((a, b) {
    if (a.missedDays != b.missedDays) {
      return a.missedDays > b.missedDays ? a : b;
    }
    return a.progressPercentage < b.progressPercentage ? a : b;
  });

  final userProfile = ref.watch(currentUserProfileProvider);
  final displayName = userProfile.valueOrNull?.displayName;

  final repo = ref.read(aiRepositoryProvider);
  return repo.getMotivation(
    goalName: target.title,
    amountLeft: target.amountRemaining,
    daysLeft: target.daysRemaining,
    streak: target.currentStreak,
    category: target.category,
    userName: displayName,
  );
});
