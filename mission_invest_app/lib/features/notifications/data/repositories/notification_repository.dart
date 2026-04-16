import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/collection_paths.dart';
import '../../../../models/notification_model.dart';

class NotificationRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(CollectionPaths.notifications);

  Stream<List<NotificationModel>> watchNotifications(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                NotificationModel.fromJson(_fromFirestore(doc.data(), doc.id)))
            .toList());
  }

  Future<void> markAsRead(String notificationId) async {
    await _collection.doc(notificationId).update({'read': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final snap = await _collection
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    if (snap.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  // ---------------------------------------------------------------------------
  // Firestore helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data, String id) {
    final json = Map<String, dynamic>.from(data);
    json['id'] = id;
    _convertTimestamps(json);
    return json;
  }

  void _convertTimestamps(Map<String, dynamic> json) {
    for (final key in json.keys) {
      if (json[key] is Timestamp) {
        json[key] = (json[key] as Timestamp).toDate().toIso8601String();
      }
    }
  }
}
