import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme_provider.dart';
import 'router.dart';

class MissionInvestApp extends ConsumerWidget {
  const MissionInvestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeDataProvider);

    return MaterialApp.router(
      title: 'Mission Invest',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
