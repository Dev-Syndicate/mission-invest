enum MissionPhase { launch, build, momentum, finalPush }

class MissionPhaseHelper {
  MissionPhaseHelper._();

  /// Determines current phase based on days elapsed.
  ///
  /// | Phase      | Days    |
  /// |------------|---------|
  /// | Launch     | 0–10    |
  /// | Build      | 11–30   |
  /// | Momentum   | 31–60   |
  /// | Final Push | 61–end  |
  static MissionPhase getPhase(int daysElapsed) {
    if (daysElapsed <= 10) return MissionPhase.launch;
    if (daysElapsed <= 30) return MissionPhase.build;
    if (daysElapsed <= 60) return MissionPhase.momentum;
    return MissionPhase.finalPush;
  }

  static String label(MissionPhase phase) {
    return switch (phase) {
      MissionPhase.launch => 'Ignition',
      MissionPhase.build => 'Building Momentum',
      MissionPhase.momentum => 'Locked In',
      MissionPhase.finalPush => 'Endgame',
    };
  }

  static String emoji(MissionPhase phase) {
    return switch (phase) {
      MissionPhase.launch => '\u{1F680}',
      MissionPhase.build => '\u{1F528}',
      MissionPhase.momentum => '\u{1F525}',
      MissionPhase.finalPush => '\u{26A1}',
    };
  }

  /// Returns progress within the current phase (0.0 to 1.0).
  static double phaseProgress(
    MissionPhase phase,
    int daysElapsed,
    int totalDays,
  ) {
    final (int start, int end) = _phaseRange(phase, totalDays);
    if (end <= start) return 1.0;
    final clamped = daysElapsed.clamp(start, end);
    return (clamped - start) / (end - start);
  }

  /// Returns the (startDay, endDay) range for the given phase.
  static (int, int) _phaseRange(MissionPhase phase, int totalDays) {
    return switch (phase) {
      MissionPhase.launch => (0, 10),
      MissionPhase.build => (11, 30),
      MissionPhase.momentum => (31, 60),
      MissionPhase.finalPush => (61, totalDays),
    };
  }

  /// Index of the phase (0-based).
  static int index(MissionPhase phase) {
    return MissionPhase.values.indexOf(phase);
  }
}
