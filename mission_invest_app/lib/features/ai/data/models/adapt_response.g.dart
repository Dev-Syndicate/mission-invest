// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adapt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdaptResponseImpl _$$AdaptResponseImplFromJson(Map<String, dynamic> json) =>
    _$AdaptResponseImpl(
      suggestion: json['suggestion'] as String,
      newDailyAmount: (json['newDailyAmount'] as num?)?.toDouble(),
      newEndDate: json['newEndDate'] as String?,
      reasoning: json['reasoning'] as String,
    );

Map<String, dynamic> _$$AdaptResponseImplToJson(_$AdaptResponseImpl instance) =>
    <String, dynamic>{
      'suggestion': instance.suggestion,
      'newDailyAmount': instance.newDailyAmount,
      'newEndDate': instance.newEndDate,
      'reasoning': instance.reasoning,
    };
