import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/providers/home_provider.dart';
import '../../data/models/team_mission_model.dart';
import '../../data/repositories/team_mission_repository.dart';

/// Re-export repository providers for convenience.
export '../../data/repositories/team_mission_repository.dart'
    show
        teamMissionRepositoryProvider,
        userTeamMissionsProvider,
        watchTeamMissionProvider;

/// Team missions for the currently authenticated user.
final currentUserTeamMissionsProvider =
    StreamProvider<List<TeamMissionModel>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(teamMissionRepositoryProvider).watchUserTeamMissions(uid);
});

/// State for team mission actions (create, contribute, invite).
class TeamActionState {
  final bool isLoading;
  final String? error;

  const TeamActionState({this.isLoading = false, this.error});
}

class TeamActionNotifier extends StateNotifier<TeamActionState> {
  TeamActionNotifier(this._repository) : super(const TeamActionState());

  final TeamMissionRepository _repository;

  Future<String?> createTeamMission(TeamMissionModel mission) async {
    state = const TeamActionState(isLoading: true);
    try {
      final id = await _repository.createTeamMission(mission);
      state = const TeamActionState();
      return id;
    } catch (e) {
      state = TeamActionState(error: e.toString());
      return null;
    }
  }

  Future<void> addContribution({
    required String teamId,
    required String userId,
    required double amount,
  }) async {
    state = const TeamActionState(isLoading: true);
    try {
      await _repository.addContribution(teamId, userId, amount);
      state = const TeamActionState();
    } catch (e) {
      state = TeamActionState(error: e.toString());
    }
  }

  Future<void> inviteMember({
    required String teamId,
    required String userId,
  }) async {
    state = const TeamActionState(isLoading: true);
    try {
      await _repository.inviteMember(teamId, userId);
      state = const TeamActionState();
    } catch (e) {
      state = TeamActionState(error: e.toString());
    }
  }

  void clearError() {
    if (state.error != null) {
      state = const TeamActionState();
    }
  }
}

final teamActionNotifierProvider =
    StateNotifierProvider<TeamActionNotifier, TeamActionState>((ref) {
  return TeamActionNotifier(ref.watch(teamMissionRepositoryProvider));
});
