import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/mission_model.dart';
import '../../data/repositories/mission_repository.dart';

final missionCreateProvider =
    StateNotifierProvider<MissionCreateNotifier, AsyncValue<void>>((ref) {
  return MissionCreateNotifier(ref.read(missionRepositoryProvider));
});

class MissionCreateNotifier extends StateNotifier<AsyncValue<void>> {
  final MissionRepository _repository;

  MissionCreateNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<String?> createMission({
    required String title,
    required String category,
    required double targetAmount,
    required int durationDays,
    required String frequency,
    String? visionImageUrl,
    String? motivationMessage,
    String? storyHeadline,
    String? personalNote,
    String? missionEmoji,
    String contractType = 'none',
  }) async {
    state = const AsyncValue.loading();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Not signed in');

      final now = DateTime.now();
      final dailyTarget = frequency == 'daily'
          ? targetAmount / durationDays
          : targetAmount / (durationDays / 7).ceil();

      final mission = MissionModel(
        id: '',
        userId: uid,
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
        storyHeadline: storyHeadline,
        personalNote: personalNote,
        missionEmoji: missionEmoji,
        contractType: contractType,
        contractStatus: contractType == 'none' ? 'none' : 'active',
        createdAt: now,
        updatedAt: now,
      );

      final docId = await _repository.createMission(mission);
      state = const AsyncValue.data(null);
      return docId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
