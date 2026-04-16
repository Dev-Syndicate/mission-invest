import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DisplayMode { win, focus }

final displayModeProvider =
    StateNotifierProvider<DisplayModeNotifier, DisplayMode>((ref) {
  return DisplayModeNotifier();
});

class DisplayModeNotifier extends StateNotifier<DisplayMode> {
  DisplayModeNotifier() : super(DisplayMode.win) {
    _loadMode();
  }

  static const _key = 'display_mode';

  Future<void> _loadMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      state = DisplayMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => DisplayMode.win,
      );
    }
  }

  Future<void> toggle() async {
    final newMode =
        state == DisplayMode.win ? DisplayMode.focus : DisplayMode.win;
    await setMode(newMode);
  }

  Future<void> setMode(DisplayMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}
