import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_model.freezed.dart';
part 'badge_model.g.dart';

enum BadgeType {
  @JsonValue('3_day_streak')
  threeDayStreak,
  @JsonValue('7_day_warrior')
  sevenDayWarrior,
  @JsonValue('30_day_survivor')
  thirtyDaySurvivor,
  @JsonValue('first_complete')
  firstComplete,
  @JsonValue('halfway_hero')
  halfwayHero,
  @JsonValue('speed_runner')
  speedRunner,
}

@freezed
class BadgeModel with _$BadgeModel {
  const factory BadgeModel({
    required String id,
    required String userId,
    required String badgeType,
    required String missionId,
    required String missionTitle,
    required DateTime earnedAt,
  }) = _BadgeModel;

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);
}

extension BadgeModelX on BadgeModel {
  String get displayName {
    switch (badgeType) {
      case '3_day_streak':
        return '3-Day Streak';
      case '7_day_warrior':
        return '7-Day Warrior';
      case '30_day_survivor':
        return '30-Day Survivor';
      case 'first_complete':
        return 'First Mission Complete';
      case 'halfway_hero':
        return 'Halfway Hero';
      case 'speed_runner':
        return 'Speed Runner';
      default:
        return badgeType;
    }
  }

  String get emoji {
    switch (badgeType) {
      case '3_day_streak':
        return '\u{1F525}';
      case '7_day_warrior':
        return '\u{1F4AA}';
      case '30_day_survivor':
        return '\u{1F4C5}';
      case 'first_complete':
        return '\u{1F3C5}';
      case 'halfway_hero':
        return '\u{1F3AF}';
      case 'speed_runner':
        return '\u{1F680}';
      default:
        return '\u{2B50}';
    }
  }
}
