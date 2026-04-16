// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nudge_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NudgeResponseImpl _$$NudgeResponseImplFromJson(Map<String, dynamic> json) =>
    _$NudgeResponseImpl(
      message: json['message'] as String,
      actionSuggestion: json['actionSuggestion'] as String?,
      suggestedParams: json['suggestedParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$NudgeResponseImplToJson(_$NudgeResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'actionSuggestion': instance.actionSuggestion,
      'suggestedParams': instance.suggestedParams,
    };
