import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../repositories/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

final adminUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(adminRepositoryProvider).getUsers();
});

final adminChallengesProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(adminRepositoryProvider).watchChallenges();
});

final featureFlagsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(adminRepositoryProvider).watchFeatureFlags();
});

final aiLogsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(adminRepositoryProvider).watchAiLogs();
});

final flaggedAiLogsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(adminRepositoryProvider).watchAiLogs(flaggedOnly: true);
});

final templatesStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.watchTemplates();
});
