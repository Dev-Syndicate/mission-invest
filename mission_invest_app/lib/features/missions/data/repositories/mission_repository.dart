import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/collection_paths.dart';
import '../models/mission_model.dart';

class MissionRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(CollectionPaths.missions);

  Stream<List<MissionModel>> watchActiveMissions(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                MissionModel.fromJson(_fromFirestore(doc.data(), doc.id)))
            .toList());
  }

  Stream<List<MissionModel>> watchAllMissions(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                MissionModel.fromJson(_fromFirestore(doc.data(), doc.id)))
            .toList());
  }

  Stream<MissionModel?> watchMission(String missionId) {
    return _collection.doc(missionId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return MissionModel.fromJson(_fromFirestore(snap.data()!, snap.id));
    });
  }

  Future<MissionModel?> getMission(String missionId) async {
    final snap = await _collection.doc(missionId).get();
    if (!snap.exists || snap.data() == null) return null;
    return MissionModel.fromJson(_fromFirestore(snap.data()!, snap.id));
  }

  Future<String> createMission(MissionModel mission) async {
    final data = _toFirestore(mission.toJson());
    final docRef = await _collection.add(data);
    return docRef.id;
  }

  Future<void> updateMission(
    String missionId,
    Map<String, dynamic> data,
  ) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _collection.doc(missionId).update(data);
  }

  Future<void> deleteMission(String missionId) async {
    await _collection.doc(missionId).delete();
  }

  Future<int> getActiveMissionCount(String userId) async {
    final snap = await _collection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .count()
        .get();
    return snap.count ?? 0;
  }

  // ---------------------------------------------------------------------------
  // Firestore ↔ JSON helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data, String id) {
    final json = Map<String, dynamic>.from(data);
    json['id'] = id;
    _convertTimestamps(json);
    return json;
  }

  Map<String, dynamic> _toFirestore(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    data.remove('id'); // id is the doc ID, not a field
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
        if (dt != null &&
            (key.endsWith('At') ||
                key.endsWith('Date') ||
                key == 'createdAt' ||
                key == 'updatedAt')) {
          data[key] = Timestamp.fromDate(dt);
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepository();
});

final activeMissionsProvider =
    StreamProvider.family<List<MissionModel>, String>((ref, userId) {
  return ref.watch(missionRepositoryProvider).watchActiveMissions(userId);
});

final allMissionsProvider =
    StreamProvider.family<List<MissionModel>, String>((ref, userId) {
  return ref.watch(missionRepositoryProvider).watchAllMissions(userId);
});

final watchMissionProvider =
    StreamProvider.family<MissionModel?, String>((ref, missionId) {
  return ref.watch(missionRepositoryProvider).watchMission(missionId);
});
