import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/providers/home_provider.dart';
import '../../data/models/season_model.dart';
import '../../data/repositories/season_repository.dart';

/// Re-export repository providers for convenience.
export '../../data/repositories/season_repository.dart'
    show
        activeSeasonsProvider,
        seasonProvider,
        seasonRepositoryProvider,
        userSeasonRankProvider;

/// Filtered active seasons for the current user's view.
final currentActiveSeasonsProvider =
    StreamProvider<List<SeasonModel>>((ref) {
  return ref.watch(seasonRepositoryProvider).watchActiveSeasons();
});

/// The user's rank in a specific season (as "Top X%").
final currentUserSeasonRankProvider =
    StreamProvider.family<int, String>((ref, seasonId) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value(100);
  return ref
      .watch(seasonRepositoryProvider)
      .watchUserRankInSeason(uid, seasonId);
});

/// State for the join-season action.
class JoinSeasonState {
  final bool isLoading;
  final String? error;

  const JoinSeasonState({this.isLoading = false, this.error});
}

class JoinSeasonNotifier extends StateNotifier<JoinSeasonState> {
  JoinSeasonNotifier(this._repository) : super(const JoinSeasonState());

  final SeasonRepository _repository;

  Future<void> join({
    required String userId,
    required String seasonId,
    required String missionId,
  }) async {
    state = const JoinSeasonState(isLoading: true);
    try {
      await _repository.joinSeason(userId, seasonId, missionId);
      state = const JoinSeasonState();
    } catch (e) {
      state = JoinSeasonState(error: e.toString());
    }
  }

  void clearError() {
    if (state.error != null) {
      state = const JoinSeasonState();
    }
  }
}

final joinSeasonNotifierProvider =
    StateNotifierProvider<JoinSeasonNotifier, JoinSeasonState>((ref) {
  return JoinSeasonNotifier(ref.watch(seasonRepositoryProvider));
});
