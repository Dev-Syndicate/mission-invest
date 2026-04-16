import '../models/user_model.dart';

class UserRepository {
  // TODO: Uncomment after Firebase setup
  // final _firestore = FirebaseFirestore.instance;
  // final _collection = FirebaseFirestore.instance.collection('users');

  Stream<UserModel?> watchUser(String uid) {
    // TODO: Replace with Firestore stream
    return Stream.value(null);
  }

  Future<UserModel?> getUser(String uid) async {
    // TODO: Replace with Firestore get
    return null;
  }

  Future<void> createUser(UserModel user) async {
    // TODO: Replace with Firestore set
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    // TODO: Replace with Firestore update
  }

  Future<void> updateFcmToken(String uid, String token) async {
    // TODO: Replace with Firestore update
  }

  Future<void> updateLastActive(String uid) async {
    // TODO: Replace with Firestore update
  }
}
