import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_provider.dart';

final adminAnalyticsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.read(adminRepositoryProvider).getAnalytics();
});
