import 'package:freezed_annotation/freezed_annotation.dart';

part 'nudge_response.freezed.dart';
part 'nudge_response.g.dart';

@freezed
class NudgeResponse with _$NudgeResponse {
  const factory NudgeResponse({
    required String message,
    String? actionSuggestion,
    Map<String, dynamic>? suggestedParams,
  }) = _NudgeResponse;

  factory NudgeResponse.fromJson(Map<String, dynamic> json) =>
      _$NudgeResponseFromJson(json);
}
