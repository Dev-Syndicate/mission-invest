import '../../../../models/notification_model.dart';

class NotificationRepository {
  // TODO: Uncomment after Firebase setup
  // final _collection = FirebaseFirestore.instance.collection('notifications');

  Stream<List<NotificationModel>> watchNotifications(String userId) {
    // TODO: Replace with Firestore query stream
    // Query: userId == userId, orderBy createdAt DESC
    return Stream.value([]);
  }

  Future<void> markAsRead(String notificationId) async {
    // TODO: Replace with Firestore update { read: true }
  }

  Future<void> markAllAsRead(String userId) async {
    // TODO: Replace with batch Firestore update
  }
}
