import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/collection_paths.dart';
import '../../../../repositories/user_repository.dart';
import '../../../missions/data/models/mission_model.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../models/confidence_score.dart';

// ---------------------------------------------------------------------------
// ConfidenceScoreService
// ---------------------------------------------------------------------------

class ConfidenceScoreService {
  final UserRepository _userRepository;
  final FirebaseFirestore _firestore;

  ConfidenceScoreService({
    required UserRepository userRepository,
    FirebaseFirestore? firestore,
  })  : _userRepository = userRepository,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Calculate the Financial Confidence Score for a user.
  ///
  /// Formula (max 1000):
  ///   streak_ratio        * 300  (current streak / longest streak across missions)
  ///   checkpoint_completion * 250  (% of checkpoints/milestones hit)
  ///   mission_completion   * 250  (completed missions / total missions)
  ///   recovery_success     * 100  (successful recoveries / total recoveries attempted)
  ///   consistency_bonus    * 100  (no missed days in last 7 days)
  Future<ConfidenceScore> calculateScore(String userId) async {
    // Fetch user data
    final user = await _userRepository.getUser(userId);
    if (user == null) return ConfidenceScore.empty;

    // Fetch all missions for this user
    final missionsSnap = await _firestore
        .collection(CollectionPaths.missions)
        .where('userId', isEqualTo: userId)
        .get();

    if (missionsSnap.docs.isEmpty) return ConfidenceScore.empty;

    final missions = missionsSnap.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      _convertTimestamps(data);
      return MissionModel.fromJson(data);
    }).toList();

    // ── 1. Streak Ratio (max 300) ──
    final streakRatio = _calculateStreakRatio(missions);
    final streakPoints = streakRatio * 300;

    // ── 2. Checkpoint / Milestone Completion (max 250) ──
    // Approximate via average progress percentage across active/completed missions
    final checkpointRate = _calculateCheckpointRate(missions);
    final checkpointPoints = checkpointRate * 250;

    // ── 3. Mission Completion Rate (max 250) ──
    final completedCount =
        missions.where((m) => m.status == 'completed').length;
    final totalMissions = missions.length;
    final missionCompletionRate =
        totalMissions > 0 ? completedCount / totalMissions : 0.0;
    final missionPoints = missionCompletionRate * 250;

    // ── 4. Recovery Success Rate (max 100) ──
    final recoveryRate = await _calculateRecoveryRate(userId);
    final recoveryPoints = recoveryRate * 100;

    // ── 5. Consistency Bonus (max 100) ──
    // Full bonus if the user contributed every day in the last 7 days
    final consistencyRate = await _calculateConsistencyBonus(userId);
    final consistencyPoints = consistencyRate * 100;

    // ── Total ──
    final rawScore = streakPoints +
        checkpointPoints +
        missionPoints +
        recoveryPoints +
        consistencyPoints;
    final score = rawScore.round().clamp(0, 1000);

    final tier = ConfidenceScore.tierFromScore(score);
    final label = ConfidenceScore.labelFromTier(tier);

    return ConfidenceScore(
      score: score,
      tier: tier,
      label: label,
      breakdown: {
        'streakRatio': streakPoints,
        'checkpointCompletion': checkpointPoints,
        'missionCompletion': missionPoints,
        'recoverySuccess': recoveryPoints,
        'consistencyBonus': consistencyPoints,
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Private calculation helpers
  // ---------------------------------------------------------------------------

  /// Ratio of current streak to longest streak across all missions.
  double _calculateStreakRatio(List<MissionModel> missions) {
    if (missions.isEmpty) return 0.0;

    int totalCurrentStreak = 0;
    int totalLongestStreak = 0;

    for (final m in missions) {
      totalCurrentStreak += m.currentStreak;
      totalLongestStreak += m.longestStreak;
    }

    if (totalLongestStreak == 0) return 0.0;
    return (totalCurrentStreak / totalLongestStreak).clamp(0.0, 1.0);
  }

  /// Average progress percentage across all missions as a proxy for
  /// checkpoint completion.
  double _calculateCheckpointRate(List<MissionModel> missions) {
    if (missions.isEmpty) return 0.0;

    double totalProgress = 0;
    for (final m in missions) {
      totalProgress += m.progressPercentage;
    }
    return (totalProgress / missions.length).clamp(0.0, 1.0);
  }

  /// Ratio of successful recoveries. If no recoveries attempted, returns 1.0
  /// (benefit of the doubt -- user never needed one).
  Future<double> _calculateRecoveryRate(String userId) async {
    final recoveriesSnap = await _firestore
        .collection(CollectionPaths.users)
        .doc(userId)
        .collection(CollectionPaths.streakRecoveries)
        .get();

    if (recoveriesSnap.docs.isEmpty) return 1.0;

    // All recorded recoveries are successful (they only get written on success),
    // so the rate is always 1.0 when there are recoveries.
    // In the future, if failed recovery attempts are tracked, adjust here.
    return 1.0;
  }

  /// Returns 1.0 if the user made at least one contribution on each of the
  /// last 7 days, 0.0 otherwise. Partial credit is given proportionally.
  Future<double> _calculateConsistencyBonus(String userId) async {
    final now = DateTime.now();
    final sevenDaysAgo = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));

    final contributionsSnap = await _firestore
        .collection(CollectionPaths.contributions)
        .where('userId', isEqualTo: userId)
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .get();

    // Collect distinct contribution dates
    final Set<String> distinctDays = {};
    for (final doc in contributionsSnap.docs) {
      final data = doc.data();
      final dateValue = data['date'];
      DateTime? dt;
      if (dateValue is Timestamp) {
        dt = dateValue.toDate();
      } else if (dateValue is String) {
        dt = DateTime.tryParse(dateValue);
      }
      if (dt != null) {
        distinctDays.add('${dt.year}-${dt.month}-${dt.day}');
      }
    }

    // 7 days of contributions = full bonus
    return (distinctDays.length / 7).clamp(0.0, 1.0);
  }

  /// Convert Timestamp fields to ISO-8601 strings for model deserialization.
  void _convertTimestamps(Map<String, dynamic> json) {
    for (final key in json.keys) {
      if (json[key] is Timestamp) {
        json[key] = (json[key] as Timestamp).toDate().toIso8601String();
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final confidenceScoreServiceProvider =
    Provider<ConfidenceScoreService>((ref) {
  return ConfidenceScoreService(
    userRepository: ref.watch(userRepositoryProvider),
  );
});

/// Async provider that calculates the confidence score for the current user.
final confidenceScoreProvider =
    FutureProvider.autoDispose<ConfidenceScore>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return ConfidenceScore.empty;
  return ref.watch(confidenceScoreServiceProvider).calculateScore(userId);
});
