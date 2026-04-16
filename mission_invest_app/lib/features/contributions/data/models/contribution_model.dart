import 'package:freezed_annotation/freezed_annotation.dart';

part 'contribution_model.freezed.dart';
part 'contribution_model.g.dart';

@freezed
class ContributionModel with _$ContributionModel {
  const factory ContributionModel({
    required String id,
    required String missionId,
    required String userId,
    required double amount,
    required DateTime date,
    @Default(0) int streakDay,
    String? note,
    required DateTime createdAt,
  }) = _ContributionModel;

  factory ContributionModel.fromJson(Map<String, dynamic> json) =>
      _$ContributionModelFromJson(json);
}
