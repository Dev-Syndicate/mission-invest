import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  // TODO: Get userId from auth state
  return Stream.value([]);
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).value ?? [];
  return notifications.where((n) => !n.read).length;
});
