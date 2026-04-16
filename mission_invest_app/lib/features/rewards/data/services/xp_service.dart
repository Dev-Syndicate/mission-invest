import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/xp_event.dart';

class XpService {
  final _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String userId) =>
      _firestore.collection('users').doc(userId);

  CollectionReference<Map<String, dynamic>> _xpEventsCollection(
          String userId) =>
      _userDoc(userId).collection('xpEvents');

  /// Awards XP to a user based on the event type.
  /// Returns the XP amount awarded.
  Future<int> awardXp(
    String userId,
    XpEventType type, {
    String? missionId,
  }) async {
    final xpAmount = XpEvent.xpFor(type);
    final docRef = _xpEventsCollection(userId).doc();

    final event = XpEvent(
      id: docRef.id,
      userId: userId,
      type: type,
      xpAmount: xpAmount,
      missionId: missionId,
      earnedAt: DateTime.now(),
    );

    final batch = _firestore.batch();

    // Add XpEvent document
    final eventData = event.toJson();
    eventData.remove('id');
    eventData['earnedAt'] = FieldValue.serverTimestamp();
    batch.set(docRef, eventData);

    // Increment user's xpTotal
    batch.update(_userDoc(userId), {
      'xpTotal': FieldValue.increment(xpAmount),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    return xpAmount;
  }

  /// Returns the user's total XP.
  Future<int> getUserXp(String userId) async {
    final snap = await _userDoc(userId).get();
    if (!snap.exists) return 0;
    return (snap.data()?['xpTotal'] as int?) ?? 0;
  }

  /// Watches the user's XP event history, ordered by most recent first.
  Stream<List<XpEvent>> watchXpHistory(String userId) {
    return _xpEventsCollection(userId)
        .orderBy('earnedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final data = Map<String, dynamic>.from(doc.data());
              data['id'] = doc.id;
              // Convert Timestamp to ISO string for the fromJson parser
              if (data['earnedAt'] is Timestamp) {
                data['earnedAt'] =
                    (data['earnedAt'] as Timestamp).toDate().toIso8601String();
              }
              return XpEvent.fromJson(data);
            }).toList());
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final xpServiceProvider = Provider<XpService>((ref) {
  return XpService();
});
