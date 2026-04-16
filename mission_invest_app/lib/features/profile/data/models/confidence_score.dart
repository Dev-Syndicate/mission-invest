/// Represents a user's Financial Confidence Score (0-1000) along with
/// the tier, human-readable label, and per-component breakdown.
class ConfidenceScore {
  /// Overall score from 0 to 1000.
  final int score;

  /// Tier from 1 (lowest) to 5 (highest).
  final int tier;

  /// Human-readable label for the tier.
  final String label;

  /// Per-component breakdown showing how many points came from each factor.
  /// Keys: 'streakRatio', 'checkpointCompletion', 'missionCompletion',
  ///        'recoverySuccess', 'consistencyBonus'
  final Map<String, double> breakdown;

  const ConfidenceScore({
    required this.score,
    required this.tier,
    required this.label,
    required this.breakdown,
  });

  /// Derive the tier (1-5) from a raw score.
  static int tierFromScore(int score) {
    if (score >= 800) return 5;
    if (score >= 600) return 4;
    if (score >= 400) return 3;
    if (score >= 200) return 2;
    return 1;
  }

  /// Derive the label from a tier number.
  static String labelFromTier(int tier) {
    switch (tier) {
      case 1:
        return 'Beginner Saver';
      case 2:
        return 'Building Habits';
      case 3:
        return 'Consistent Saver';
      case 4:
        return 'Mission Pro';
      case 5:
        return 'Financial Athlete';
      default:
        return 'Beginner Saver';
    }
  }

  /// A zero/empty score for users with no data yet.
  static const ConfidenceScore empty = ConfidenceScore(
    score: 0,
    tier: 1,
    label: 'Beginner Saver',
    breakdown: {
      'streakRatio': 0,
      'checkpointCompletion': 0,
      'missionCompletion': 0,
      'recoverySuccess': 0,
      'consistencyBonus': 0,
    },
  );
}
