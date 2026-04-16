import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
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
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkOnSurface,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      elevation: 2,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: Colors.grey,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
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
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightOnSurface,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.lightSurface,
      elevation: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: Colors.grey,
    ),
  );

  static ThemeData gamingTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
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
      backgroundColor: AppColors.gamingSurface,
      foregroundColor: AppColors.gamingOnSurface,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.gamingSurface,
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.gamingSurface,
      selectedItemColor: AppColors.gamingPrimary,
      unselectedItemColor: Colors.grey,
    ),
  );

  static ThemeData pastelTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
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
      backgroundColor: AppColors.pastelSurface,
      foregroundColor: AppColors.pastelOnSurface,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.pastelSurface,
      elevation: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.pastelSurface,
      selectedItemColor: AppColors.pastelPrimary,
      unselectedItemColor: Colors.grey,
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
