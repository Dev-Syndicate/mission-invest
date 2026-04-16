// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamMissionModelImpl _$$TeamMissionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TeamMissionModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  targetAmount: (json['targetAmount'] as num).toDouble(),
  memberIds:
      (json['memberIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  contributions:
      (json['contributions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  status: json['status'] as String? ?? 'active',
  createdAt: DateTime.parse(json['createdAt'] as String),
  createdBy: json['createdBy'] as String,
);

Map<String, dynamic> _$$TeamMissionModelImplToJson(
  _$TeamMissionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'targetAmount': instance.targetAmount,
  'memberIds': instance.memberIds,
  'contributions': instance.contributions,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'createdBy': instance.createdBy,
};
