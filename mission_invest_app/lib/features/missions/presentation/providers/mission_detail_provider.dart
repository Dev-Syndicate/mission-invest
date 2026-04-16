import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/mission_model.dart';
import 'mission_list_provider.dart';

final missionDetailProvider =
    StreamProvider.family<MissionModel?, String>((ref, missionId) {
  return ref.read(missionRepositoryProvider).watchMission(missionId);
});
