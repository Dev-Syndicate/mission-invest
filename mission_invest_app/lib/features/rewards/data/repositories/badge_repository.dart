import '../models/badge_model.dart';

class BadgeRepository {
  // TODO: Uncomment after Firebase setup
  // final _collection = FirebaseFirestore.instance.collection('badges');

  Stream<List<BadgeModel>> watchUserBadges(String userId) {
    // TODO: Replace with Firestore query stream
    // Query: userId == userId, orderBy earnedAt DESC
    return Stream.value([]);
  }

  Future<List<BadgeModel>> getUserBadges(String userId) async {
    // TODO: Replace with Firestore query
    return [];
  }
}
