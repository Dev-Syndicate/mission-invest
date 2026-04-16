import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/notifications/data/services/notification_service.dart';
import '../repositories/user_repository.dart';
import 'router.dart';

class MissionInvestApp extends ConsumerStatefulWidget {
  const MissionInvestApp({super.key});

  @override
  ConsumerState<MissionInvestApp> createState() => _MissionInvestAppState();
}

class _MissionInvestAppState extends ConsumerState<MissionInvestApp> {
  bool _fcmInitialised = false;

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(themeDataProvider);

    // Initialise FCM once when a user is authenticated
    ref.listen(authStateChangesProvider, (prev, next) {
      final user = next.valueOrNull;
      if (user != null && !_fcmInitialised) {
        _fcmInitialised = true;
        ref.read(notificationServiceProvider).init(
              userId: user.uid,
              userRepository: ref.read(userRepositoryProvider),
            );
      }
      if (user == null) {
        _fcmInitialised = false;
      }
    });

    return MaterialApp.router(
      title: 'Mission Invest',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
