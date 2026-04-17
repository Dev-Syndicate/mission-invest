import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/marketplace_item.dart';
import '../../data/models/xp_event.dart';
import '../../data/demo/demo_marketplace_items.dart';
import '../../data/repositories/marketplace_repository.dart';
import '../../data/services/xp_service.dart';
import '../../../home/presentation/providers/home_provider.dart';

// ── All marketplace items (static demo data + Firestore items merged) ──

final marketplaceItemsProvider = StreamProvider<List<MarketplaceItem>>((ref) {
  return ref.watch(marketplaceRepositoryProvider).watchAllItems().map((firestoreItems) {
    if (firestoreItems.isNotEmpty) return firestoreItems;
    return demoMarketplaceItems;
  });
});

// ── User's owned item IDs ──

final userOwnedItemsProvider = StreamProvider<List<String>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(marketplaceRepositoryProvider).watchOwnedItems(userId);
});

// ── User XP totals from user profile ──

final userXpTotalProvider = Provider<int>((ref) {
  final profile = ref.watch(currentUserProfileProvider).valueOrNull;
  if (profile == null) return 0;
  // xpTotal and xpSpent may not exist on the freezed model yet,
  // so we read them from the raw user doc via a dedicated provider.
  return 0; // Fallback — overridden by userXpDataProvider below.
});

/// Watches raw xp fields from the user document.
final userXpDataProvider = StreamProvider<_XpData>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const _XpData(0, 0));
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((snap) {
    final data = snap.data() ?? {};
    return _XpData(
      (data['xpTotal'] as int?) ?? 0,
      (data['xpSpent'] as int?) ?? 0,
    );
  });
});

class _XpData {
  final int total;
  final int spent;
  const _XpData(this.total, this.spent);
  int get available => total - spent;
}

/// Available XP balance (total - spent).
final userXpBalanceProvider = Provider<int>((ref) {
  final xpData = ref.watch(userXpDataProvider).valueOrNull;
  return xpData?.available ?? 0;
});

/// Total XP earned.
final userXpTotalEarnedProvider = Provider<int>((ref) {
  final xpData = ref.watch(userXpDataProvider).valueOrNull;
  return xpData?.total ?? 0;
});

// ── XP history ──

final userXpHistoryProvider = StreamProvider<List<XpEvent>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(xpServiceProvider).watchXpHistory(userId);
});

// ── Filtered marketplace items ──

final selectedMarketplaceFilterProvider =
    StateProvider<MarketplaceItemType?>((ref) => null);

final filteredMarketplaceItemsProvider =
    Provider<AsyncValue<List<MarketplaceItem>>>((ref) {
  final filter = ref.watch(selectedMarketplaceFilterProvider);
  final itemsAsync = ref.watch(marketplaceItemsProvider);

  return itemsAsync.whenData((items) {
    if (filter == null) return items;
    return items.where((item) => item.type == filter).toList();
  });
});
