import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

final selectedThemeNameProvider =
    StateNotifierProvider<ThemeNotifier, String>((ref) {
  return ThemeNotifier();
});

final themeDataProvider = Provider<ThemeData>((ref) {
  final themeName = ref.watch(selectedThemeNameProvider);
  return AppTheme.getTheme(themeName);
});

class ThemeNotifier extends StateNotifier<String> {
  ThemeNotifier() : super('dark') {
    _loadTheme();
  }

  static const _key = 'selected_theme';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> setTheme(String themeName) async {
    state = themeName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, themeName);
  }
}
