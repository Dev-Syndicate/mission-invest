import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/mission_model.dart';
import '../../data/repositories/mission_repository.dart';

// Re-export contribution providers so consumers can import from one place.
export '../../../contributions/presentation/providers/contribution_provider.dart'
    show missionContributionsProvider;

/// Watches a single mission document by ID.
final missionDetailProvider =
    StreamProvider.family<MissionModel?, String>((ref, missionId) {
  return ref.watch(missionRepositoryProvider).watchMission(missionId);
});
