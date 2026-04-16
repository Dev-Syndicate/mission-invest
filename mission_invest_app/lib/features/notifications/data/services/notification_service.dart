import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../repositories/user_repository.dart';

/// Top-level handler for background messages (must be a top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM background message: ${message.messageId}');
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _localInitialised = false;

  static const _reminderChannel = AndroidNotificationChannel(
    'mission_invest_reminders',
    'Daily Reminders',
    description: 'Daily savings reminder notifications',
    importance: Importance.high,
  );

  static const _alertChannel = AndroidNotificationChannel(
    'mission_invest_alerts',
    'Streak Alerts',
    description: 'Streak risk and break alerts',
    importance: Importance.high,
  );

  static const _milestoneChannel = AndroidNotificationChannel(
    'mission_invest_milestones',
    'Milestones',
    description: 'Mission milestone and completion celebrations',
    importance: Importance.high,
  );

  Future<void> _initLocal() async {
    if (_localInitialised) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(settings: initSettings);

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_reminderChannel);
      await androidPlugin.createNotificationChannel(_alertChannel);
      await androidPlugin.createNotificationChannel(_milestoneChannel);
    }

    _localInitialised = true;
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String channelId = 'mission_invest_reminders',
  }) async {
    await _initLocal();

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == 'mission_invest_alerts'
          ? 'Streak Alerts'
          : channelId == 'mission_invest_milestones'
              ? 'Milestones'
              : 'Daily Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _initLocal();

    const androidDetails = AndroidNotificationDetails(
      'mission_invest_reminders',
      'Daily Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.cancel(id: 0);

    await _localNotifications.periodicallyShowWithDuration(
      id: 0,
      title: title,
      body: body,
      repeatDurationInterval: const Duration(hours: 24),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    debugPrint('Scheduled daily reminder at $hour:$minute');
  }

  Future<void> cancelDailyReminder() async {
    await _initLocal();
    await _localNotifications.cancel(id: 0);
  }

  Future<void> init({
    required String userId,
    required UserRepository userRepository,
  }) async {
    await _initLocal();

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('FCM permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    final token = await _messaging.getToken();
    if (token != null) {
      debugPrint('FCM token: $token');
      await userRepository.updateFcmToken(userId, token);
    }

    _messaging.onTokenRefresh.listen((newToken) {
      userRepository.updateFcmToken(userId, newToken);
    });

    // Show local notification for foreground FCM messages
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM foreground message: ${message.notification?.title}');
      final notification = message.notification;
      if (notification != null) {
        final channelId = message.data['type'] == 'streak_alert'
            ? 'mission_invest_alerts'
            : message.data['type'] == 'milestone' ||
                    message.data['type'] == 'mission_complete'
                ? 'mission_invest_milestones'
                : 'mission_invest_reminders';

        _showLocalNotification(
          title: notification.title ?? 'Mission Invest',
          body: notification.body ?? '',
          channelId: channelId,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('FCM message opened app: ${message.data}');
    });

    // Schedule local daily reminder based on user preference
    final user = await userRepository.getUser(userId);
    if (user != null && user.notificationsEnabled) {
      final parts = user.notificationTime.split(':');
      final hour = int.tryParse(parts[0]) ?? 9;
      final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
      await scheduleDailyReminder(
        hour: hour,
        minute: minute,
        title: 'Time to save!',
        body: 'Log your daily contribution and keep your streak alive.',
      );
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
