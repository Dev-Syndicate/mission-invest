class AppConstants {
  AppConstants._();

  static const String appName = 'Mission Invest';

  // Mission constraints
  static const int maxActiveMissions = 3;
  static const int minMissionDurationDays = 10;
  static const int maxMissionDurationDays = 180;
  static const double minContributionAmount = 10.0;
  static const double minTargetAmount = 100.0;

  // Streak
  static const int streakRecoveryCooldownDays = 7;

  // AI
  static const int aiRateLimitPerMinute = 10;

  // Notifications
  static const String defaultNotificationTime = '09:00';
}
