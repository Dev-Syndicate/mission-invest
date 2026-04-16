import 'package:cloud_firestore/cloud_firestore.dart';

enum XpEventType {
  dailyContribution,
  checkpointReached,
  missionCompleted,
  streak7,
  streak30,
  streak60,
  speedRunner,
  seasonCompletion,
}

class XpEvent {
  final String id;
  final String userId;
  final XpEventType type;
  final int xpAmount;
  final String? missionId;
  final DateTime earnedAt;

  const XpEvent({
    required this.id,
    required this.userId,
    required this.type,
    required this.xpAmount,
    this.missionId,
    required this.earnedAt,
  });

  static const Map<XpEventType, int> xpRates = {
    XpEventType.dailyContribution: 10,
    XpEventType.checkpointReached: 50,
    XpEventType.missionCompleted: 200,
    XpEventType.streak7: 75,
    XpEventType.streak30: 150,
    XpEventType.streak60: 300,
    XpEventType.speedRunner: 250,
    XpEventType.seasonCompletion: 500,
  };

  static int xpFor(XpEventType type) => xpRates[type] ?? 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'type': type.name,
        'xpAmount': xpAmount,
        'missionId': missionId,
        'earnedAt': earnedAt.toIso8601String(),
      };

  factory XpEvent.fromJson(Map<String, dynamic> json) {
    return XpEvent(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: XpEventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => XpEventType.dailyContribution,
      ),
      xpAmount: json['xpAmount'] as int,
      missionId: json['missionId'] as String?,
      earnedAt: json['earnedAt'] is Timestamp
          ? (json['earnedAt'] as Timestamp).toDate()
          : DateTime.parse(json['earnedAt'] as String),
    );
  }

  String get displayName {
    switch (type) {
      case XpEventType.dailyContribution:
        return 'Daily Contribution';
      case XpEventType.checkpointReached:
        return 'Checkpoint Reached';
      case XpEventType.missionCompleted:
        return 'Mission Completed';
      case XpEventType.streak7:
        return '7-Day Streak';
      case XpEventType.streak30:
        return '30-Day Streak';
      case XpEventType.streak60:
        return '60-Day Streak';
      case XpEventType.speedRunner:
        return 'Speed Runner';
      case XpEventType.seasonCompletion:
        return 'Season Completion';
    }
  }
}
