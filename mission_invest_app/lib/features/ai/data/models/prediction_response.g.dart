// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PredictionResponseImpl _$$PredictionResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PredictionResponseImpl(
  completionProbability: (json['completionProbability'] as num).toDouble(),
  riskLevel: json['riskLevel'] as String,
  factors:
      (json['factors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$PredictionResponseImplToJson(
  _$PredictionResponseImpl instance,
) => <String, dynamic>{
  'completionProbability': instance.completionProbability,
  'riskLevel': instance.riskLevel,
  'factors': instance.factors,
};
