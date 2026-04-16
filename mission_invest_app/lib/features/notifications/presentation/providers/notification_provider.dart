import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/notification_model.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(notificationRepositoryProvider).watchNotifications(userId);
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).value ?? [];
  return notifications.where((n) => !n.read).length;
});
