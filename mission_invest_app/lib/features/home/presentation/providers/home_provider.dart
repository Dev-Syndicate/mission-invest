import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../missions/data/models/mission_model.dart';
import '../../../missions/data/repositories/mission_repository.dart';
import '../../../rewards/data/models/badge_model.dart';
import '../../../rewards/data/repositories/badge_repository.dart';
import '../../../../models/user_model.dart';
import '../../../../repositories/user_repository.dart';

// ── Auth helpers ──

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.valueOrNull?.uid;
});

// ── User profile stream ──

final currentUserProfileProvider = StreamProvider<UserModel?>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchUser(uid);
});

// ── Active missions for current user ──

final homeActiveMissionsProvider = StreamProvider<List<MissionModel>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(missionRepositoryProvider).watchActiveMissions(uid);
});

// ── Recent badges for current user ──

final homeRecentBadgesProvider = StreamProvider<List<BadgeModel>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(badgeRepositoryProvider).watchUserBadges(uid);
});

// ── Greeting ──

final homeGreetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
});

// ── Category emoji helper ──

String categoryEmoji(String category) {
  switch (category) {
    case 'trip':
      return '\u{2708}\u{FE0F}';
    case 'gadget':
      return '\u{1F4F1}';
    case 'vehicle':
      return '\u{1F697}';
    case 'emergency':
      return '\u{1F6D1}';
    case 'course':
      return '\u{1F4DA}';
    case 'gift':
      return '\u{1F381}';
    case 'custom':
    default:
      return '\u{1F3AF}';
  }
}
