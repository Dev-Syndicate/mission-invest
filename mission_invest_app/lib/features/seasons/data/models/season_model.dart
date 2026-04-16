import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_model.freezed.dart';
part 'season_model.g.dart';

@freezed
class SeasonModel with _$SeasonModel {
  const factory SeasonModel({
    required String id,
    required String title,
    required String category, // trip, gadget, education, etc.
    required DateTime startDate,
    required DateTime endDate,
    @Default(0) int participantCount,
    @Default(0.0) double completionRate,
    String? badgeId,
    String? bannerImageUrl,
    @Default(true) bool isActive,
  }) = _SeasonModel;

  factory SeasonModel.fromJson(Map<String, dynamic> json) =>
      _$SeasonModelFromJson(json);
}

extension SeasonModelX on SeasonModel {
  int get daysRemaining {
    final diff = endDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  bool get hasStarted => DateTime.now().isAfter(startDate);

  bool get hasEnded => DateTime.now().isAfter(endDate);

  Duration get duration => endDate.difference(startDate);
}
