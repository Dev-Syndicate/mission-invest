import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mission_repository.dart';
import '../../data/models/mission_model.dart';
import '../../../home/presentation/providers/home_provider.dart';

final activeMissionsProvider = StreamProvider<List<MissionModel>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(missionRepositoryProvider).watchActiveMissions(userId);
});

final allMissionsProvider = StreamProvider<List<MissionModel>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(missionRepositoryProvider).watchAllMissions(userId);
});

final canCreateMissionProvider = Provider<bool>((ref) {
  final missions = ref.watch(activeMissionsProvider).value ?? [];
  return missions.length < 3;
});
