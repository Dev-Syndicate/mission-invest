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

  /// Seeds the marketplace collection with demo items.
  /// Skips if items already exist. Returns the number of items created.
  Future<int> seedDemoItems() async {
    final existing = await _marketplaceCollection.limit(1).get();
    if (existing.docs.isNotEmpty) {
      throw Exception('Marketplace already has items. Clear them first to re-seed.');
    }

    final batch = _firestore.batch();

    for (final item in _demoMarketplaceItems) {
      final docRef = _marketplaceCollection.doc();
      batch.set(docRef, {
        ...item.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    return _demoMarketplaceItems.length;
  }

  /// Deletes all marketplace items.
  Future<int> clearAllItems() async {
    final snap = await _marketplaceCollection.get();
    if (snap.docs.isEmpty) return 0;

    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    return snap.docs.length;
  }
}

// ---------------------------------------------------------------------------
// Demo Data
// ---------------------------------------------------------------------------

const _demoMarketplaceItems = [
  // ── Badges ──
  MarketplaceItem(id: '', name: 'Early Bird', type: MarketplaceItemType.badge, cost: 50, rarity: ItemRarity.common, description: 'For those who start saving before sunrise. Show off your early commitment!'),
  MarketplaceItem(id: '', name: 'Streak Master', type: MarketplaceItemType.badge, cost: 150, rarity: ItemRarity.uncommon, description: 'Prove your consistency with this streak-themed badge on your profile.'),
  MarketplaceItem(id: '', name: 'Diamond Hands', type: MarketplaceItemType.badge, cost: 500, rarity: ItemRarity.epic, description: 'You never gave up on your mission. A badge for the truly committed.'),
  MarketplaceItem(id: '', name: 'Mission Legend', type: MarketplaceItemType.badge, cost: 1000, rarity: ItemRarity.legendary, description: 'The ultimate badge. Only for those who have conquered multiple missions.'),
  MarketplaceItem(id: '', name: 'First Steps', type: MarketplaceItemType.badge, cost: 25, rarity: ItemRarity.common, description: 'Everyone starts somewhere. Celebrate your first contribution!'),
  MarketplaceItem(id: '', name: 'Comeback Kid', type: MarketplaceItemType.badge, cost: 200, rarity: ItemRarity.rare, description: 'Recovered a broken streak and came back stronger than ever.'),

  // ── Themes ──
  MarketplaceItem(id: '', name: 'Midnight Blue', type: MarketplaceItemType.theme, cost: 300, rarity: ItemRarity.rare, description: 'A sleek dark blue theme that makes your dashboard feel premium.'),
  MarketplaceItem(id: '', name: 'Sunset Gradient', type: MarketplaceItemType.theme, cost: 200, rarity: ItemRarity.uncommon, description: 'Warm orange-to-pink gradient theme for a vibrant savings experience.'),
  MarketplaceItem(id: '', name: 'Neon Glow', type: MarketplaceItemType.theme, cost: 750, rarity: ItemRarity.epic, description: 'Electric neon accents on a dark background. Cyberpunk vibes for your finances.'),
  MarketplaceItem(id: '', name: 'Forest Calm', type: MarketplaceItemType.theme, cost: 150, rarity: ItemRarity.uncommon, description: 'A soothing green palette inspired by nature. Save in peace.'),
  MarketplaceItem(id: '', name: 'Golden Hour', type: MarketplaceItemType.theme, cost: 1200, rarity: ItemRarity.legendary, description: 'Luxurious gold accents on deep black. The theme of champions.'),

  // ── Certificate Styles ──
  MarketplaceItem(id: '', name: 'Classic Parchment', type: MarketplaceItemType.certificateStyle, cost: 100, rarity: ItemRarity.common, description: 'A timeless parchment-style certificate for your completed missions.'),
  MarketplaceItem(id: '', name: 'Modern Minimal', type: MarketplaceItemType.certificateStyle, cost: 175, rarity: ItemRarity.uncommon, description: 'Clean, modern certificate design with bold typography.'),
  MarketplaceItem(id: '', name: 'Royal Seal', type: MarketplaceItemType.certificateStyle, cost: 400, rarity: ItemRarity.rare, description: 'An ornate certificate with a golden seal and decorative borders.'),
  MarketplaceItem(id: '', name: 'Holographic', type: MarketplaceItemType.certificateStyle, cost: 800, rarity: ItemRarity.epic, description: 'A futuristic holographic certificate that shimmers with achievement.'),

  // ── Avatar Frames ──
  MarketplaceItem(id: '', name: 'Bronze Ring', type: MarketplaceItemType.avatarFrame, cost: 75, rarity: ItemRarity.common, description: 'A simple bronze frame to surround your profile picture.'),
  MarketplaceItem(id: '', name: 'Silver Laurel', type: MarketplaceItemType.avatarFrame, cost: 250, rarity: ItemRarity.uncommon, description: 'A laurel wreath frame in silver. Victory looks good on you.'),
  MarketplaceItem(id: '', name: 'Gold Crown', type: MarketplaceItemType.avatarFrame, cost: 500, rarity: ItemRarity.rare, description: 'A golden crown frame. Rule your savings kingdom.'),
  MarketplaceItem(id: '', name: 'Fire Ring', type: MarketplaceItemType.avatarFrame, cost: 700, rarity: ItemRarity.epic, description: 'An animated fire ring frame for the hottest savers.'),
  MarketplaceItem(id: '', name: 'Cosmic Halo', type: MarketplaceItemType.avatarFrame, cost: 1500, rarity: ItemRarity.legendary, description: 'A swirling galaxy halo around your avatar. Truly out of this world.'),

  // ── Profile Effects ──
  MarketplaceItem(id: '', name: 'Sparkle Trail', type: MarketplaceItemType.profileEffect, cost: 100, rarity: ItemRarity.common, description: 'Subtle sparkle particles on your profile. A touch of magic.'),
  MarketplaceItem(id: '', name: 'Confetti Burst', type: MarketplaceItemType.profileEffect, cost: 250, rarity: ItemRarity.uncommon, description: 'Colorful confetti rains down on your profile. Party mode!'),
  MarketplaceItem(id: '', name: 'Rain of Coins', type: MarketplaceItemType.profileEffect, cost: 400, rarity: ItemRarity.rare, description: 'Golden coins cascade across your profile. Money vibes only.'),
  MarketplaceItem(id: '', name: 'Aurora Borealis', type: MarketplaceItemType.profileEffect, cost: 900, rarity: ItemRarity.epic, description: 'Mesmerizing northern lights dance across your profile background.'),
  MarketplaceItem(id: '', name: 'Lightning Storm', type: MarketplaceItemType.profileEffect, cost: 1800, rarity: ItemRarity.legendary, description: 'Electric lightning bolts crackle on your profile. Pure power.'),
];

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepository();
});
