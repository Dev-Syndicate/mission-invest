enum MarketplaceItemType { badge, theme, certificateStyle, avatarFrame, profileEffect }

enum ItemRarity { common, uncommon, rare, epic, legendary }

class MarketplaceItem {
  final String id;
  final String name;
  final MarketplaceItemType type;
  final int cost;
  final ItemRarity rarity;
  final String? previewUrl;
  final String description;

  const MarketplaceItem({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
    required this.rarity,
    this.previewUrl,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'cost': cost,
        'rarity': rarity.name,
        'previewUrl': previewUrl,
        'description': description,
      };

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceItem(
      id: json['id'] as String,
      name: json['name'] as String,
      type: MarketplaceItemType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MarketplaceItemType.badge,
      ),
      cost: json['cost'] as int,
      rarity: ItemRarity.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => ItemRarity.common,
      ),
      previewUrl: json['previewUrl'] as String?,
      description: json['description'] as String,
    );
  }

  String get rarityLabel {
    switch (rarity) {
      case ItemRarity.common:
        return 'Common';
      case ItemRarity.uncommon:
        return 'Uncommon';
      case ItemRarity.rare:
        return 'Rare';
      case ItemRarity.epic:
        return 'Epic';
      case ItemRarity.legendary:
        return 'Legendary';
    }
  }

  String get typeLabel {
    switch (type) {
      case MarketplaceItemType.badge:
        return 'Badge';
      case MarketplaceItemType.theme:
        return 'Theme';
      case MarketplaceItemType.certificateStyle:
        return 'Certificate';
      case MarketplaceItemType.avatarFrame:
        return 'Avatar Frame';
      case MarketplaceItemType.profileEffect:
        return 'Profile Effect';
    }
  }
}
