import 'mission_model.dart';

enum ContractType { halfPledge, consistencyPact, speedPact, none }

enum ContractStatus { active, inRecovery, breached, fulfilled, none }

class MissionContract {
  final ContractType type;
  final ContractStatus status;
  final DateTime? recoveryDeadline;

  const MissionContract({
    this.type = ContractType.none,
    this.status = ContractStatus.none,
    this.recoveryDeadline,
  });

  /// Human-readable name for a contract type.
  static String name(ContractType type) {
    return switch (type) {
      ContractType.halfPledge => 'Half-Pledge',
      ContractType.consistencyPact => 'Consistency Pact',
      ContractType.speedPact => 'Speed Pact',
      ContractType.none => 'No Contract',
    };
  }

  /// Detailed description for each contract type.
  static String description(ContractType type) {
    return switch (type) {
      ContractType.halfPledge =>
        'Commit to saving at least 50% of your target amount. '
            'If you fall below halfway by the midpoint, you enter recovery.',
      ContractType.consistencyPact =>
        'Commit to contributing every day without breaking your streak. '
            'Miss 3 days total and the contract is breached.',
      ContractType.speedPact =>
        'Commit to completing the mission ahead of schedule. '
            'Finish in 80% of the planned duration or less.',
      ContractType.none => 'No commitment \u2014 save at your own pace.',
    };
  }

  /// Recovery condition text shown to the user.
  static String recoveryCondition(ContractType type) {
    return switch (type) {
      ContractType.halfPledge =>
        'Catch up to 50% within 3 days of the midpoint.',
      ContractType.consistencyPact =>
        'Resume daily contributions for 5 consecutive days.',
      ContractType.speedPact =>
        'Get back on pace within the next 7 days.',
      ContractType.none => '',
    };
  }

  /// Icon data string for each contract type.
  static String iconName(ContractType type) {
    return switch (type) {
      ContractType.halfPledge => 'shield',
      ContractType.consistencyPact => 'bolt',
      ContractType.speedPact => 'speed',
      ContractType.none => 'block',
    };
  }

  /// Check if the contract conditions have been breached based on mission state.
  bool checkBreach(MissionModel mission) {
    switch (type) {
      case ContractType.halfPledge:
        // Breached if past midpoint and less than 50% saved
        final midpoint = mission.durationDays / 2;
        if (mission.daysElapsed >= midpoint &&
            mission.progressPercentage < 0.5) {
          // Check if recovery deadline has passed
          if (recoveryDeadline != null &&
              DateTime.now().isAfter(recoveryDeadline!)) {
            return true;
          }
        }
        return false;

      case ContractType.consistencyPact:
        // Breached if missed 3+ days total
        return mission.missedDays >= 3;

      case ContractType.speedPact:
        // Breached if past 80% of duration without completion
        final speedTarget = mission.durationDays * 0.8;
        if (mission.daysElapsed > speedTarget && !mission.isCompleted) {
          if (recoveryDeadline != null &&
              DateTime.now().isAfter(recoveryDeadline!)) {
            return true;
          }
        }
        return false;

      case ContractType.none:
        return false;
    }
  }

  /// Serialize to JSON for Firestore storage.
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'status': status.name,
      'recoveryDeadline': recoveryDeadline?.toIso8601String(),
    };
  }

  /// Deserialize from JSON.
  factory MissionContract.fromJson(Map<String, dynamic> json) {
    return MissionContract(
      type: ContractType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ContractType.none,
      ),
      status: ContractStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ContractStatus.none,
      ),
      recoveryDeadline: json['recoveryDeadline'] != null
          ? DateTime.tryParse(json['recoveryDeadline'] as String)
          : null,
    );
  }
}
