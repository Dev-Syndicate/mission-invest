import 'package:flutter_riverpod/flutter_riverpod.dart';

// Home screen aggregates data from multiple providers.
// This file is for any home-screen-specific derived state.

final homeGreetingProvider = Provider<String>((ref) {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
});
