import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/collection_paths.dart';
import '../models/user_model.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(CollectionPaths.users);

  Stream<UserModel?> watchUser(String uid) {
    return _collection.doc(uid).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return UserModel.fromJson(_fromFirestore(snap.data()!, snap.id));
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final snap = await _collection.doc(uid).get();
    if (!snap.exists || snap.data() == null) return null;
    return UserModel.fromJson(_fromFirestore(snap.data()!, snap.id));
  }

  Future<void> createUser(UserModel user) async {
    await _collection.doc(user.uid).set(_toFirestore(user.toJson()));
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _collection.doc(uid).update(data);
  }

  Future<void> updateFcmToken(String uid, String token) async {
    await _collection.doc(uid).update({
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateLastActive(String uid) async {
    await _collection.doc(uid).update({
      'lastActiveAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Convert Firestore document data to a JSON map suitable for fromJson.
  /// Converts Timestamp fields to ISO-8601 strings.
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data, String id) {
    final json = Map<String, dynamic>.from(data);
    json['uid'] = id;
    _convertTimestamps(json);
    return json;
  }

  /// Convert a model JSON map to Firestore-friendly data.
  /// Converts DateTime ISO strings to Timestamps.
  Map<String, dynamic> _toFirestore(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    data.remove('uid'); // uid is the doc ID, not a field
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

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final watchUserProvider =
    StreamProvider.family<UserModel?, String>((ref, uid) {
  return ref.watch(userRepositoryProvider).watchUser(uid);
});
