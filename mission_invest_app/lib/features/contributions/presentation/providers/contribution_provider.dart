import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/contribution_repository.dart';
import '../../data/models/contribution_model.dart';

final contributionRepositoryProvider = Provider<ContributionRepository>((ref) {
  return ContributionRepository();
});

final missionContributionsProvider =
    StreamProvider.family<List<ContributionModel>, String>((ref, missionId) {
  return ref.read(contributionRepositoryProvider).watchContributions(missionId);
});

final todayContributionsProvider =
    StreamProvider<List<ContributionModel>>((ref) {
  // TODO: Get userId from auth state
  return Stream.value([]);
});
