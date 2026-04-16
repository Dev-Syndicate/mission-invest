import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/marketplace_item.dart';
import '../../data/repositories/marketplace_repository.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/marketplace_item_card.dart';
import '../../../home/presentation/providers/home_provider.dart';

class MarketplacePage extends ConsumerWidget {
  const MarketplacePage({super.key});

  static const _filterOptions = <MapEntry<MarketplaceItemType?, String>>[
    MapEntry(null, 'All'),
    MapEntry(MarketplaceItemType.badge, 'Badges'),
    MapEntry(MarketplaceItemType.theme, 'Themes'),
    MapEntry(MarketplaceItemType.certificateStyle, 'Certificates'),
    MapEntry(MarketplaceItemType.avatarFrame, 'Frames'),
    MapEntry(MarketplaceItemType.profileEffect, 'Effects'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xpBalance = ref.watch(userXpBalanceProvider);
    final selectedFilter = ref.watch(selectedMarketplaceFilterProvider);
    final filteredItemsAsync = ref.watch(filteredMarketplaceItemsProvider);
    final ownedItemsAsync = ref.watch(userOwnedItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded,
                    size: 20, color: Colors.amber.shade600),
                const SizedBox(width: 4),
                Text(
                  '$xpBalance XP',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filterOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final option = _filterOptions[index];
                final isSelected = selectedFilter == option.key;
                return FilterChip(
                  label: Text(option.value),
                  selected: isSelected,
                  onSelected: (_) {
                    ref
                        .read(selectedMarketplaceFilterProvider.notifier)
                        .state = option.key;
                  },
                );
              },
            ),
          ),
          // Items grid
          Expanded(
            child: filteredItemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text('Error loading items: $err'),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(filteredMarketplaceItemsProvider);
                      ref.invalidate(userOwnedItemsProvider);
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.storefront_outlined,
                                  size: 64,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withAlpha(128),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No items available',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Check back later for new items!',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withAlpha(153),
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final ownedIds =
                    ownedItemsAsync.valueOrNull ?? <String>[];

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(filteredMarketplaceItemsProvider);
                    ref.invalidate(userOwnedItemsProvider);
                  },
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isOwned = ownedIds.contains(item.id);
                      return MarketplaceItemCard(
                        item: item,
                        isOwned: isOwned,
                        onTap: () => _showItemDetail(
                          context,
                          ref,
                          item,
                          isOwned,
                          xpBalance,
                        ),
                      ).animate().fadeIn(
                            duration: 300.ms,
                            delay: (50 * index).ms,
                          ).slideY(
                            begin: 0.1,
                            duration: 300.ms,
                            delay: (50 * index).ms,
                          );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showItemDetail(
    BuildContext context,
    WidgetRef ref,
    MarketplaceItem item,
    bool isOwned,
    int xpBalance,
  ) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withAlpha(60),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                // Item icon/preview
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _rarityColor(item.rarity).withAlpha(40),
                  ),
                  child: Icon(
                    _typeIcon(item.type),
                    size: 40,
                    color: _rarityColor(item.rarity),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _rarityColor(item.rarity).withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${item.rarityLabel} ${item.typeLabel}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: _rarityColor(item.rarity),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(180),
                  ),
                ),
                const SizedBox(height: 20),
                // XP cost row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_rounded,
                        size: 24, color: Colors.amber.shade600),
                    const SizedBox(width: 6),
                    Text(
                      '${item.cost} XP',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Purchase / Owned button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: isOwned
                      ? OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Owned'),
                        )
                      : FilledButton.icon(
                          onPressed: xpBalance >= item.cost
                              ? () => _confirmPurchase(context, ref, item)
                              : null,
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: Text(
                            xpBalance >= item.cost
                                ? 'Purchase'
                                : 'Not enough XP',
                          ),
                        ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmPurchase(
      BuildContext context, WidgetRef ref, MarketplaceItem item) {
    Navigator.of(context).pop(); // Close bottom sheet

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Purchase'),
        content: Text(
          'Spend ${item.cost} XP to purchase "${item.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _executePurchase(context, ref, item);
            },
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  Future<void> _executePurchase(
      BuildContext context, WidgetRef ref, MarketplaceItem item) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    try {
      await ref
          .read(marketplaceRepositoryProvider)
          .purchaseItem(userId, item);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchased "${item.name}" successfully!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase failed: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Color _rarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey;
      case ItemRarity.uncommon:
        return Colors.green;
      case ItemRarity.rare:
        return Colors.blue;
      case ItemRarity.epic:
        return Colors.purple;
      case ItemRarity.legendary:
        return Colors.orange;
    }
  }

  IconData _typeIcon(MarketplaceItemType type) {
    switch (type) {
      case MarketplaceItemType.badge:
        return Icons.emoji_events;
      case MarketplaceItemType.theme:
        return Icons.palette;
      case MarketplaceItemType.certificateStyle:
        return Icons.card_membership;
      case MarketplaceItemType.avatarFrame:
        return Icons.account_circle;
      case MarketplaceItemType.profileEffect:
        return Icons.auto_awesome;
    }
  }
}
