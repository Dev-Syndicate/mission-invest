// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SeasonModelImpl _$$SeasonModelImplFromJson(Map<String, dynamic> json) =>
    _$SeasonModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0.0,
      badgeId: json['badgeId'] as String?,
      bannerImageUrl: json['bannerImageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$SeasonModelImplToJson(_$SeasonModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'participantCount': instance.participantCount,
      'completionRate': instance.completionRate,
      'badgeId': instance.badgeId,
      'bannerImageUrl': instance.bannerImageUrl,
      'isActive': instance.isActive,
    };
