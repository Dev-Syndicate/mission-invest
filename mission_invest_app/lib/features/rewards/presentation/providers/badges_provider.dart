import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/badge_repository.dart';
import '../../data/models/badge_model.dart';
import '../../../home/presentation/providers/home_provider.dart';

final userBadgesProvider = StreamProvider<List<BadgeModel>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(badgeRepositoryProvider).watchUserBadges(userId);
});

final badgeCountProvider = Provider<int>((ref) {
  return ref.watch(userBadgesProvider).value?.length ?? 0;
});
