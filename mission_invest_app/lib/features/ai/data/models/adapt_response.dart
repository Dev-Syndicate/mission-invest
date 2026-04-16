import 'package:freezed_annotation/freezed_annotation.dart';

part 'adapt_response.freezed.dart';
part 'adapt_response.g.dart';

@freezed
class AdaptResponse with _$AdaptResponse {
  const factory AdaptResponse({
    required String suggestion,
    double? newDailyAmount,
    String? newEndDate,
    required String reasoning,
  }) = _AdaptResponse;

  factory AdaptResponse.fromJson(Map<String, dynamic> json) =>
      _$AdaptResponseFromJson(json);
}
