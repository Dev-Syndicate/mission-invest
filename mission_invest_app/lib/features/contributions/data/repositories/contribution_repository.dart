import '../models/contribution_model.dart';

class ContributionRepository {
  // TODO: Uncomment after Firebase setup
  // final _collection = FirebaseFirestore.instance.collection('contributions');

  Stream<List<ContributionModel>> watchContributions(String missionId) {
    // TODO: Replace with Firestore query stream
    // Query: missionId == missionId, orderBy date DESC
    return Stream.value([]);
  }

  Stream<List<ContributionModel>> watchTodayContributions(String userId) {
    // TODO: Replace with Firestore query stream
    // Query: userId == userId, date == today
    return Stream.value([]);
  }

  Future<String> addContribution(ContributionModel contribution) async {
    // TODO: Replace with Firestore add, return doc ID
    return '';
  }
}
