import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/badge_repository.dart';
import '../../data/models/badge_model.dart';

final badgeRepositoryProvider = Provider<BadgeRepository>((ref) {
  return BadgeRepository();
});

final userBadgesProvider = StreamProvider<List<BadgeModel>>((ref) {
  // TODO: Get userId from auth state
  return Stream.value([]);
});

final badgeCountProvider = Provider<int>((ref) {
  return ref.watch(userBadgesProvider).value?.length ?? 0;
});
