import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/ai_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(ref.read(apiClientProvider));
});
