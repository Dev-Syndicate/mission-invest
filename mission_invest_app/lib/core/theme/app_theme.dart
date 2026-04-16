import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ── Shared constants ──
  static const _borderRadius = 16.0;
  static const _cardRadius = 20.0;
  static const _fontFamily = 'Inter';

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSurface: AppColors.darkOnSurface,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.darkOnSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.darkPrimary.withAlpha(30),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.darkPrimary, size: 24);
        }
        return IconThemeData(
            color: AppColors.darkOnSurface.withAlpha(120), size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.darkPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          );
        }
        return TextStyle(
          color: AppColors.darkOnSurface.withAlpha(120),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        );
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.darkOnSurface.withAlpha(20),
      thickness: 0.5,
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.darkPrimary
              : null),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.darkPrimary.withAlpha(80)
              : null),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSurface: AppColors.lightOnSurface,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.lightOnSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.lightPrimary.withAlpha(30),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.lightPrimary, size: 24);
        }
        return IconThemeData(
            color: AppColors.lightOnSurface.withAlpha(120), size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColors.lightPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          );
        }
        return TextStyle(
          color: AppColors.lightOnSurface.withAlpha(120),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        );
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceVariant.withAlpha(80),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide:
            const BorderSide(color: AppColors.lightPrimary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightOnSurface.withAlpha(20),
      thickness: 0.5,
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.lightPrimary
              : null),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.lightPrimary.withAlpha(80)
              : null),
    ),
  );

  static ThemeData gamingTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gamingPrimary,
      secondary: AppColors.gamingSecondary,
      surface: AppColors.gamingSurface,
      error: AppColors.gamingError,
      onPrimary: AppColors.gamingOnPrimary,
      onSurface: AppColors.gamingOnSurface,
    ),
    scaffoldBackgroundColor: AppColors.gamingBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.gamingOnSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.gamingSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.gamingPrimary.withAlpha(30),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.gamingPrimary,
        foregroundColor: AppColors.gamingOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF252540),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static ThemeData pastelTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    colorScheme: const ColorScheme.light(
      primary: AppColors.pastelPrimary,
      secondary: AppColors.pastelSecondary,
      surface: AppColors.pastelSurface,
      error: AppColors.pastelError,
      onPrimary: AppColors.pastelOnPrimary,
      onSurface: AppColors.pastelOnSurface,
    ),
    scaffoldBackgroundColor: AppColors.pastelBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.pastelOnSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.pastelSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.pastelPrimary.withAlpha(30),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.pastelPrimary,
        foregroundColor: AppColors.pastelOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFF5F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static ThemeData getTheme(String themeName) {
    switch (themeName) {
      case 'light':
        return lightTheme;
      case 'gaming':
        return gamingTheme;
      case 'pastel':
        return pastelTheme;
      case 'dark':
      default:
        return darkTheme;
    }
  }
}
