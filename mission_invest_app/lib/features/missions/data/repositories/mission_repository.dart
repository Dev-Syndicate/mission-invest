import '../models/mission_model.dart';

class MissionRepository {
  // TODO: Uncomment after Firebase setup
  // final _collection = FirebaseFirestore.instance.collection('missions');

  Stream<List<MissionModel>> watchActiveMissions(String userId) {
    // TODO: Replace with Firestore query stream
    // Query: userId == userId, status == 'active', orderBy createdAt DESC
    return Stream.value([]);
  }

  Stream<List<MissionModel>> watchAllMissions(String userId) {
    // TODO: Replace with Firestore query stream
    // Query: userId == userId, orderBy createdAt DESC
    return Stream.value([]);
  }

  Stream<MissionModel?> watchMission(String missionId) {
    // TODO: Replace with Firestore doc stream
    return Stream.value(null);
  }

  Future<MissionModel?> getMission(String missionId) async {
    // TODO: Replace with Firestore get
    return null;
  }

  Future<String> createMission(MissionModel mission) async {
    // TODO: Replace with Firestore add, return doc ID
    return '';
  }

  Future<void> updateMission(
    String missionId,
    Map<String, dynamic> data,
  ) async {
    // TODO: Replace with Firestore update
  }

  Future<int> getActiveMissionCount(String userId) async {
    // TODO: Replace with Firestore count query
    return 0;
  }
}
