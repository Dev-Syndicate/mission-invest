import 'package:freezed_annotation/freezed_annotation.dart';

part 'motivation_response.freezed.dart';
part 'motivation_response.g.dart';

@freezed
class MotivationResponse with _$MotivationResponse {
  const factory MotivationResponse({
    required String message,
    required String tone,
  }) = _MotivationResponse;

  factory MotivationResponse.fromJson(Map<String, dynamic> json) =>
      _$MotivationResponseFromJson(json);
}
