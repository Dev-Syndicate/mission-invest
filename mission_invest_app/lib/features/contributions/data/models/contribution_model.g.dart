// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContributionModelImpl _$$ContributionModelImplFromJson(
  Map<String, dynamic> json,
) => _$ContributionModelImpl(
  id: json['id'] as String,
  missionId: json['missionId'] as String,
  userId: json['userId'] as String,
  amount: (json['amount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  streakDay: (json['streakDay'] as num?)?.toInt() ?? 0,
  note: json['note'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$ContributionModelImplToJson(
  _$ContributionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'missionId': instance.missionId,
  'userId': instance.userId,
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'streakDay': instance.streakDay,
  'note': instance.note,
  'createdAt': instance.createdAt.toIso8601String(),
};
