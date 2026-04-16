import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_mission_model.freezed.dart';
part 'team_mission_model.g.dart';

@freezed
class TeamMissionModel with _$TeamMissionModel {
  const factory TeamMissionModel({
    required String id,
    required String title,
    required double targetAmount,
    @Default([]) List<String> memberIds,
    @Default({}) Map<String, double> contributions, // userId -> amount
    @Default('active') String status, // active, completed
    required DateTime createdAt,
    required String createdBy,
  }) = _TeamMissionModel;

  factory TeamMissionModel.fromJson(Map<String, dynamic> json) =>
      _$TeamMissionModelFromJson(json);
}

extension TeamMissionModelX on TeamMissionModel {
  double get totalContributed =>
      contributions.values.fold(0.0, (sum, v) => sum + v);

  double get progressPercentage =>
      targetAmount > 0 ? (totalContributed / targetAmount).clamp(0.0, 1.0) : 0.0;

  double get amountRemaining =>
      (targetAmount - totalContributed).clamp(0.0, targetAmount);

  bool get isCompleted => status == 'completed';

  int get memberCount => memberIds.length;

  /// Returns each member's contribution as a fraction of total contributed.
  /// Privacy-safe: shows percentage, not absolute amount.
  Map<String, double> get memberContributionPercentages {
    final total = totalContributed;
    if (total <= 0) return {};
    return contributions.map((uid, amount) => MapEntry(uid, amount / total));
  }
}
