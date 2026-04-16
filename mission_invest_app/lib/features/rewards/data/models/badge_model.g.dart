// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeModelImpl _$$BadgeModelImplFromJson(Map<String, dynamic> json) =>
    _$BadgeModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      badgeType: json['badgeType'] as String,
      missionId: json['missionId'] as String,
      missionTitle: json['missionTitle'] as String,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
    );

Map<String, dynamic> _$$BadgeModelImplToJson(_$BadgeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'badgeType': instance.badgeType,
      'missionId': instance.missionId,
      'missionTitle': instance.missionTitle,
      'earnedAt': instance.earnedAt.toIso8601String(),
    };
