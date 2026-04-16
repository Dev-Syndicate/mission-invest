// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MissionModelImpl _$$MissionModelImplFromJson(Map<String, dynamic> json) =>
    _$MissionModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      savedAmount: (json['savedAmount'] as num?)?.toDouble() ?? 0,
      dailyTarget: (json['dailyTarget'] as num).toDouble(),
      frequency: json['frequency'] as String? ?? 'daily',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      durationDays: (json['durationDays'] as num).toInt(),
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastContributionDate: json['lastContributionDate'] == null
          ? null
          : DateTime.parse(json['lastContributionDate'] as String),
      missedDays: (json['missedDays'] as num?)?.toInt() ?? 0,
      recoveryUsedThisWeek: json['recoveryUsedThisWeek'] as bool? ?? false,
      recoveryWeekStart: json['recoveryWeekStart'] == null
          ? null
          : DateTime.parse(json['recoveryWeekStart'] as String),
      completionProbability:
          (json['completionProbability'] as num?)?.toDouble() ?? 1.0,
      status: json['status'] as String? ?? 'active',
      visionImageUrl: json['visionImageUrl'] as String?,
      motivationMessage: json['motivationMessage'] as String?,
      storyHeadline: json['storyHeadline'] as String?,
      personalNote: json['personalNote'] as String?,
      missionEmoji: json['missionEmoji'] as String?,
      contractType: json['contractType'] as String? ?? 'none',
      contractStatus: json['contractStatus'] as String? ?? 'none',
      contractRecoveryDeadline: json['contractRecoveryDeadline'] == null
          ? null
          : DateTime.parse(json['contractRecoveryDeadline'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$MissionModelImplToJson(_$MissionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'category': instance.category,
      'targetAmount': instance.targetAmount,
      'savedAmount': instance.savedAmount,
      'dailyTarget': instance.dailyTarget,
      'frequency': instance.frequency,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'durationDays': instance.durationDays,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'lastContributionDate': instance.lastContributionDate?.toIso8601String(),
      'missedDays': instance.missedDays,
      'recoveryUsedThisWeek': instance.recoveryUsedThisWeek,
      'recoveryWeekStart': instance.recoveryWeekStart?.toIso8601String(),
      'completionProbability': instance.completionProbability,
      'status': instance.status,
      'visionImageUrl': instance.visionImageUrl,
      'motivationMessage': instance.motivationMessage,
      'storyHeadline': instance.storyHeadline,
      'personalNote': instance.personalNote,
      'missionEmoji': instance.missionEmoji,
      'contractType': instance.contractType,
      'contractStatus': instance.contractStatus,
      'contractRecoveryDeadline': instance.contractRecoveryDeadline
          ?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
