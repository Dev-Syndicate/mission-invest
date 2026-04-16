import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/marketplace_item.dart';

class MarketplaceItemCard extends StatelessWidget {
  final MarketplaceItem item;
  final bool isOwned;
  final VoidCallback onTap;

  const MarketplaceItemCard({
    super.key,
    required this.item,
    required this.isOwned,
    required this.onTap,
  });

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rarityColor = _rarityColor(item.rarity);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: rarityColor.withAlpha(isOwned ? 180 : 80),
            width: isOwned ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview area
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      rarityColor.withAlpha(30),
                      rarityColor.withAlpha(60),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: item.previewUrl != null &&
                              item.previewUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: item.previewUrl!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.contain,
                              placeholder: (_, _) =>
                                  const CircularProgressIndicator(
                                      strokeWidth: 2),
                              errorWidget: (_, _, _) => Icon(
                                _typeIcon(item.type),
                                size: 48,
                                color: rarityColor,
                              ),
                            )
                          : Icon(
                              _typeIcon(item.type),
                              size: 48,
                              color: rarityColor,
                            ),
                    ),
                    // Rarity badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: rarityColor.withAlpha(200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.rarityLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    // Owned tag
                    if (isOwned)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(220),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Owned',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.typeLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.amber.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.cost} XP',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
