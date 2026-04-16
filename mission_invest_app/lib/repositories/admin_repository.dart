import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminRepository {
  final _firestore = FirebaseFirestore.instance;
  final _functions = FirebaseFunctions.instance;

  // ---------------------------------------------------------------------------
  // Analytics
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getAnalytics() async {
    final callable = _functions.httpsCallable('getAdminAnalytics');
    final result = await callable.call<Map<String, dynamic>>();
    final data = result.data;
    if (data['success'] == true && data['data'] is Map) {
      return Map<String, dynamic>.from(data['data'] as Map);
    }
    return Map<String, dynamic>.from(data);
  }

  // ---------------------------------------------------------------------------
  // Users
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getUsers() async {
    final snap = await _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs
        .map((doc) => _fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Templates
  // ---------------------------------------------------------------------------

  Stream<List<Map<String, dynamic>>> watchTemplates() {
    return _firestore
        .collection('templates')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => _fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> createTemplate(Map<String, dynamic> data) async {
    final payload = Map<String, dynamic>.from(data);
    payload['createdAt'] = FieldValue.serverTimestamp();
    payload['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('templates').add(payload);
  }

  Future<void> updateTemplate(
    String templateId,
    Map<String, dynamic> data,
  ) async {
    final payload = Map<String, dynamic>.from(data);
    payload['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('templates').doc(templateId).update(payload);
  }

  Future<void> deleteTemplate(String templateId) async {
    await _firestore.collection('templates').doc(templateId).delete();
  }

  // ---------------------------------------------------------------------------
  // Feature Flags
  // ---------------------------------------------------------------------------

  Stream<List<Map<String, dynamic>>> watchFeatureFlags() {
    return _firestore
        .collection('featureFlags')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => _fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> toggleFeatureFlag(String flagId, bool enabled) async {
    await _firestore.collection('featureFlags').doc(flagId).update({
      'enabled': enabled,
    });
  }

  // ---------------------------------------------------------------------------
  // Challenges
  // ---------------------------------------------------------------------------

  Stream<List<Map<String, dynamic>>> watchChallenges() {
    return _firestore
        .collection('challenges')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => _fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> createChallenge(Map<String, dynamic> data) async {
    final payload = Map<String, dynamic>.from(data);
    payload['createdAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('challenges').add(payload);
  }

  Future<void> deleteChallenge(String challengeId) async {
    await _firestore.collection('challenges').doc(challengeId).delete();
  }

  // ---------------------------------------------------------------------------
  // Broadcast Notifications
  // ---------------------------------------------------------------------------

  Future<void> sendBroadcast({
    required String title,
    required String body,
    String? segment,
  }) async {
    final callable = _functions.httpsCallable('sendBroadcast');
    await callable.call<Map<String, dynamic>>({
      'title': title,
      'body': body,
      'segment': segment,
    });
  }

  // ---------------------------------------------------------------------------
  // AI Logs
  // ---------------------------------------------------------------------------

  Stream<List<Map<String, dynamic>>> watchAiLogs({bool flaggedOnly = false}) {
    Query<Map<String, dynamic>> query = _firestore
        .collection('aiLogs')
        .orderBy('createdAt', descending: true);

    if (flaggedOnly) {
      query = query.where('flagged', isEqualTo: true);
    }

    return query.snapshots().map((snap) => snap.docs
        .map((doc) => _fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<void> flagAiLog(String logId, bool flagged) async {
    await _firestore.collection('aiLogs').doc(logId).update({
      'flagged': flagged,
    });
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

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});
