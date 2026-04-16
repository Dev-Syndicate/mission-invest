import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/mission_model.dart';
import 'mission_list_provider.dart';

final missionCreateProvider =
    StateNotifierProvider<MissionCreateNotifier, AsyncValue<void>>((ref) {
  return MissionCreateNotifier(ref.read(missionRepositoryProvider));
});

class MissionCreateNotifier extends StateNotifier<AsyncValue<void>> {
  final dynamic _repository;

  MissionCreateNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> createMission({
    required String title,
    required String category,
    required double targetAmount,
    required int durationDays,
    required String frequency,
    String? visionImageUrl,
    String? motivationMessage,
  }) async {
    state = const AsyncValue.loading();
    try {
      final now = DateTime.now();
      final dailyTarget = frequency == 'daily'
          ? targetAmount / durationDays
          : targetAmount / (durationDays / 7).ceil();

      final mission = MissionModel(
        id: '',
        userId: '', // TODO: Get from auth
        title: title,
        category: category,
        targetAmount: targetAmount,
        dailyTarget: dailyTarget,
        frequency: frequency,
        startDate: now,
        endDate: now.add(Duration(days: durationDays)),
        durationDays: durationDays,
        visionImageUrl: visionImageUrl,
        motivationMessage: motivationMessage,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.createMission(mission);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
