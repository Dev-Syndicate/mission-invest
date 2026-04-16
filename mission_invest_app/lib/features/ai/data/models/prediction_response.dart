import 'package:freezed_annotation/freezed_annotation.dart';

part 'prediction_response.freezed.dart';
part 'prediction_response.g.dart';

@freezed
class PredictionResponse with _$PredictionResponse {
  const factory PredictionResponse({
    required double completionProbability,
    required String riskLevel,
    @Default([]) List<String> factors,
  }) = _PredictionResponse;

  factory PredictionResponse.fromJson(Map<String, dynamic> json) =>
      _$PredictionResponseFromJson(json);
}
