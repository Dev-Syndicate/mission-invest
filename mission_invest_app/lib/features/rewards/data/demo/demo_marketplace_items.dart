import '../models/marketplace_item.dart';

const demoMarketplaceItems = <MarketplaceItem>[
  // ── Badges ──
  MarketplaceItem(id: 'demo_badge_1', name: 'Early Bird', type: MarketplaceItemType.badge, cost: 50, rarity: ItemRarity.common, description: 'For those who start saving before sunrise. Show off your early commitment!'),
  MarketplaceItem(id: 'demo_badge_2', name: 'Streak Master', type: MarketplaceItemType.badge, cost: 150, rarity: ItemRarity.uncommon, description: 'Prove your consistency with this streak-themed badge on your profile.'),
  MarketplaceItem(id: 'demo_badge_3', name: 'Diamond Hands', type: MarketplaceItemType.badge, cost: 500, rarity: ItemRarity.epic, description: 'You never gave up on your mission. A badge for the truly committed.'),
  MarketplaceItem(id: 'demo_badge_4', name: 'Mission Legend', type: MarketplaceItemType.badge, cost: 1000, rarity: ItemRarity.legendary, description: 'The ultimate badge. Only for those who have conquered multiple missions.'),
  MarketplaceItem(id: 'demo_badge_5', name: 'First Steps', type: MarketplaceItemType.badge, cost: 25, rarity: ItemRarity.common, description: 'Everyone starts somewhere. Celebrate your first contribution!'),
  MarketplaceItem(id: 'demo_badge_6', name: 'Comeback Kid', type: MarketplaceItemType.badge, cost: 200, rarity: ItemRarity.rare, description: 'Recovered a broken streak and came back stronger than ever.'),

  // ── Themes ──
  MarketplaceItem(id: 'demo_theme_1', name: 'Midnight Blue', type: MarketplaceItemType.theme, cost: 300, rarity: ItemRarity.rare, description: 'A sleek dark blue theme that makes your dashboard feel premium.'),
  MarketplaceItem(id: 'demo_theme_2', name: 'Sunset Gradient', type: MarketplaceItemType.theme, cost: 200, rarity: ItemRarity.uncommon, description: 'Warm orange-to-pink gradient theme for a vibrant savings experience.'),
  MarketplaceItem(id: 'demo_theme_3', name: 'Neon Glow', type: MarketplaceItemType.theme, cost: 750, rarity: ItemRarity.epic, description: 'Electric neon accents on a dark background. Cyberpunk vibes for your finances.'),
  MarketplaceItem(id: 'demo_theme_4', name: 'Forest Calm', type: MarketplaceItemType.theme, cost: 150, rarity: ItemRarity.uncommon, description: 'A soothing green palette inspired by nature. Save in peace.'),
  MarketplaceItem(id: 'demo_theme_5', name: 'Golden Hour', type: MarketplaceItemType.theme, cost: 1200, rarity: ItemRarity.legendary, description: 'Luxurious gold accents on deep black. The theme of champions.'),

  // ── Certificate Styles ──
  MarketplaceItem(id: 'demo_cert_1', name: 'Classic Parchment', type: MarketplaceItemType.certificateStyle, cost: 100, rarity: ItemRarity.common, description: 'A timeless parchment-style certificate for your completed missions.'),
  MarketplaceItem(id: 'demo_cert_2', name: 'Modern Minimal', type: MarketplaceItemType.certificateStyle, cost: 175, rarity: ItemRarity.uncommon, description: 'Clean, modern certificate design with bold typography.'),
  MarketplaceItem(id: 'demo_cert_3', name: 'Royal Seal', type: MarketplaceItemType.certificateStyle, cost: 400, rarity: ItemRarity.rare, description: 'An ornate certificate with a golden seal and decorative borders.'),
  MarketplaceItem(id: 'demo_cert_4', name: 'Holographic', type: MarketplaceItemType.certificateStyle, cost: 800, rarity: ItemRarity.epic, description: 'A futuristic holographic certificate that shimmers with achievement.'),

  // ── Avatar Frames ──
  MarketplaceItem(id: 'demo_frame_1', name: 'Bronze Ring', type: MarketplaceItemType.avatarFrame, cost: 75, rarity: ItemRarity.common, description: 'A simple bronze frame to surround your profile picture.'),
  MarketplaceItem(id: 'demo_frame_2', name: 'Silver Laurel', type: MarketplaceItemType.avatarFrame, cost: 250, rarity: ItemRarity.uncommon, description: 'A laurel wreath frame in silver. Victory looks good on you.'),
  MarketplaceItem(id: 'demo_frame_3', name: 'Gold Crown', type: MarketplaceItemType.avatarFrame, cost: 500, rarity: ItemRarity.rare, description: 'A golden crown frame. Rule your savings kingdom.'),
  MarketplaceItem(id: 'demo_frame_4', name: 'Fire Ring', type: MarketplaceItemType.avatarFrame, cost: 700, rarity: ItemRarity.epic, description: 'An animated fire ring frame for the hottest savers.'),
  MarketplaceItem(id: 'demo_frame_5', name: 'Cosmic Halo', type: MarketplaceItemType.avatarFrame, cost: 1500, rarity: ItemRarity.legendary, description: 'A swirling galaxy halo around your avatar. Truly out of this world.'),

  // ── Profile Effects ──
  MarketplaceItem(id: 'demo_effect_1', name: 'Sparkle Trail', type: MarketplaceItemType.profileEffect, cost: 100, rarity: ItemRarity.common, description: 'Subtle sparkle particles on your profile. A touch of magic.'),
  MarketplaceItem(id: 'demo_effect_2', name: 'Confetti Burst', type: MarketplaceItemType.profileEffect, cost: 250, rarity: ItemRarity.uncommon, description: 'Colorful confetti rains down on your profile. Party mode!'),
  MarketplaceItem(id: 'demo_effect_3', name: 'Rain of Coins', type: MarketplaceItemType.profileEffect, cost: 400, rarity: ItemRarity.rare, description: 'Golden coins cascade across your profile. Money vibes only.'),
  MarketplaceItem(id: 'demo_effect_4', name: 'Aurora Borealis', type: MarketplaceItemType.profileEffect, cost: 900, rarity: ItemRarity.epic, description: 'Mesmerizing northern lights dance across your profile background.'),
  MarketplaceItem(id: 'demo_effect_5', name: 'Lightning Storm', type: MarketplaceItemType.profileEffect, cost: 1800, rarity: ItemRarity.legendary, description: 'Electric lightning bolts crackle on your profile. Pure power.'),
];
