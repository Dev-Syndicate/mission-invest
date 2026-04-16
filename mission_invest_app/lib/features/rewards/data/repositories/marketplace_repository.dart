import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_item.dart';

class MarketplaceRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _marketplaceCollection =>
      _firestore.collection('marketplace');

  DocumentReference<Map<String, dynamic>> _userDoc(String userId) =>
      _firestore.collection('users').doc(userId);

  /// Watches all marketplace items.
  Stream<List<MarketplaceItem>> watchAllItems() {
    return _marketplaceCollection.snapshots().map((snap) => snap.docs
        .map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          return MarketplaceItem.fromJson(data);
        })
        .toList());
  }

  /// Returns items filtered by type.
  Future<List<MarketplaceItem>> getItemsByType(
      MarketplaceItemType type) async {
    final snap = await _marketplaceCollection
        .where('type', isEqualTo: type.name)
        .get();
    return snap.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      return MarketplaceItem.fromJson(data);
    }).toList();
  }

  /// Purchases a marketplace item for the user.
  /// Throws [Exception] if the user doesn't have enough XP.
  Future<void> purchaseItem(String userId, MarketplaceItem item) async {
    final userSnap = await _userDoc(userId).get();
    if (!userSnap.exists) throw Exception('User not found');

    final data = userSnap.data()!;
    final xpTotal = (data['xpTotal'] as int?) ?? 0;
    final xpSpent = (data['xpSpent'] as int?) ?? 0;
    final availableXp = xpTotal - xpSpent;

    if (availableXp < item.cost) {
      throw Exception(
          'Insufficient XP. You need ${item.cost} XP but only have $availableXp available.');
    }

    // Check if already owned
    final ownedItems = List<String>.from(data['ownedItems'] ?? []);
    if (ownedItems.contains(item.id)) {
      throw Exception('You already own this item.');
    }

    await _userDoc(userId).update({
      'ownedItems': FieldValue.arrayUnion([item.id]),
      'xpSpent': FieldValue.increment(item.cost),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Checks if a user owns a specific item.
  Future<bool> ownsItem(String userId, String itemId) async {
    final snap = await _userDoc(userId).get();
    if (!snap.exists) return false;
    final ownedItems = List<String>.from(snap.data()?['ownedItems'] ?? []);
    return ownedItems.contains(itemId);
  }

  /// Watches the list of owned item IDs for a user.
  Stream<List<String>> watchOwnedItems(String userId) {
    return _userDoc(userId).snapshots().map((snap) {
      if (!snap.exists) return <String>[];
      return List<String>.from(snap.data()?['ownedItems'] ?? []);
    });
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepository();
});
