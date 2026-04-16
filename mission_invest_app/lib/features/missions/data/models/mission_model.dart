import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_model.freezed.dart';
part 'mission_model.g.dart';

enum MissionStatus { active, completed, failed, paused }

enum MissionCategory { trip, gadget, vehicle, emergency, course, gift, custom }

enum MissionFrequency { daily, weekly }

@freezed
class MissionModel with _$MissionModel {
  const factory MissionModel({
    required String id,
    required String userId,
    required String title,
    required String category,
    required double targetAmount,
    @Default(0) double savedAmount,
    required double dailyTarget,
    @Default('daily') String frequency,
    required DateTime startDate,
    required DateTime endDate,
    required int durationDays,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    DateTime? lastContributionDate,
    @Default(0) int missedDays,
    @Default(false) bool recoveryUsedThisWeek,
    DateTime? recoveryWeekStart,
    @Default(1.0) double completionProbability,
    @Default('active') String status,
    String? visionImageUrl,
    String? motivationMessage,
    // Story card fields
    String? storyHeadline,
    String? personalNote,
    String? missionEmoji,
    // Commit contract fields
    @Default('none') String contractType,
    @Default('none') String contractStatus,
    DateTime? contractRecoveryDeadline,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? completedAt,
  }) = _MissionModel;

  factory MissionModel.fromJson(Map<String, dynamic> json) =>
      _$MissionModelFromJson(json);
}

extension MissionModelX on MissionModel {
  double get progressPercentage =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  int get daysRemaining {
    final diff = endDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  int get daysElapsed {
    final diff = DateTime.now().difference(startDate).inDays;
    return diff < 0 ? 0 : diff;
  }

  double get amountRemaining => (targetAmount - savedAmount).clamp(0, targetAmount);

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
}
