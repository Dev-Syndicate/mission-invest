import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mission_repository.dart';
import '../../data/models/mission_model.dart';

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepository();
});

final activeMissionsProvider = StreamProvider<List<MissionModel>>((ref) {
  // TODO: Get userId from auth state
  // final userId = ref.watch(authStateProvider).value?.uid;
  // if (userId == null) return Stream.value([]);
  // return ref.read(missionRepositoryProvider).watchActiveMissions(userId);
  return Stream.value([]);
});

final allMissionsProvider = StreamProvider<List<MissionModel>>((ref) {
  // TODO: Get userId from auth state
  return Stream.value([]);
});

final canCreateMissionProvider = Provider<bool>((ref) {
  final missions = ref.watch(activeMissionsProvider).value ?? [];
  return missions.length < 3;
});
