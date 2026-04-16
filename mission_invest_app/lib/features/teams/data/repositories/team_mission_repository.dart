import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team_mission_model.dart';

class TeamMissionRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('teamMissions');

  /// Watches all team missions where the user is a member.
  Stream<List<TeamMissionModel>> watchUserTeamMissions(String userId) {
    return _collection
        .where('memberIds', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                TeamMissionModel.fromJson(_fromFirestore(doc.data(), doc.id)))
            .toList());
  }

  /// Fetches a single team mission by ID.
  Future<TeamMissionModel?> getTeamMission(String teamId) async {
    final snap = await _collection.doc(teamId).get();
    if (!snap.exists || snap.data() == null) return null;
    return TeamMissionModel.fromJson(_fromFirestore(snap.data()!, snap.id));
  }

  /// Watches a single team mission.
  Stream<TeamMissionModel?> watchTeamMission(String teamId) {
    return _collection.doc(teamId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return TeamMissionModel.fromJson(_fromFirestore(snap.data()!, snap.id));
    });
  }

  /// Creates a new team mission. Returns the document ID.
  Future<String> createTeamMission(TeamMissionModel mission) async {
    final data = _toFirestore(mission.toJson());
    final docRef = await _collection.add(data);
    return docRef.id;
  }

  /// Adds a contribution from a user to a team mission.
  Future<void> addContribution(
    String teamId,
    String userId,
    double amount,
  ) async {
    await _collection.doc(teamId).update({
      'contributions.$userId': FieldValue.increment(amount),
    });
  }

  /// Invites a member to a team mission (adds them to memberIds).
  Future<void> inviteMember(String teamId, String userId) async {
    await _collection.doc(teamId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
    });
  }

  // ---------------------------------------------------------------------------
  // Firestore helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data, String id) {
    final json = Map<String, dynamic>.from(data);
    json['id'] = id;
    _convertTimestamps(json);
    // Ensure contributions map has correct types.
    if (json['contributions'] is Map) {
      json['contributions'] = (json['contributions'] as Map).map(
        (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
      );
    }
    return json;
  }

  Map<String, dynamic> _toFirestore(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    data.remove('id');
    _convertDateTimesToTimestamps(data);
    return data;
  }

  void _convertTimestamps(Map<String, dynamic> json) {
    for (final key in json.keys) {
      if (json[key] is Timestamp) {
        json[key] = (json[key] as Timestamp).toDate().toIso8601String();
      }
    }
  }

  void _convertDateTimesToTimestamps(Map<String, dynamic> data) {
    for (final key in data.keys) {
      final value = data[key];
      if (value is String) {
        final dt = DateTime.tryParse(value);
        if (dt != null && (key.endsWith('At') || key.endsWith('Date'))) {
          data[key] = Timestamp.fromDate(dt);
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final teamMissionRepositoryProvider = Provider<TeamMissionRepository>((ref) {
  return TeamMissionRepository();
});

final userTeamMissionsProvider =
    StreamProvider.family<List<TeamMissionModel>, String>((ref, userId) {
  return ref
      .watch(teamMissionRepositoryProvider)
      .watchUserTeamMissions(userId);
});

final watchTeamMissionProvider =
    StreamProvider.family<TeamMissionModel?, String>((ref, teamId) {
  return ref.watch(teamMissionRepositoryProvider).watchTeamMission(teamId);
});
