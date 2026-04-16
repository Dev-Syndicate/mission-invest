import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Premium Fintech Palette ──
  static const accent = Color(0xFF174D38);
  static const accentLight = Color(0xFF1E6B4E);
  static const accentDark = Color(0xFF0F3426);
  static const expense = Color(0xFF4D1717);
  static const expenseLight = Color(0xFF6B2A2A);

  // ── Dark Theme (Primary) ──
  static const darkPrimary = Color(0xFF2ECC71);
  static const darkSecondary = Color(0xFF27AE60);
  static const darkBackground = Color(0xFF000000);
  static const darkSurface = Color(0xFF111111);
  static const darkSurfaceLight = Color(0xFF1A1A1A);
  static const darkError = Color(0xFFE74C3C);
  static const darkOnPrimary = Color(0xFF000000);
  static const darkOnBackground = Color(0xFFE8F5E9);
  static const darkOnSurface = Color(0xFFE0E0E0);

  // ── Light Theme ──
  static const lightPrimary = Color(0xFF174D38);
  static const lightSecondary = Color(0xFF27AE60);
  static const lightBackground = Color(0xFFF2F2F2);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFCBCBCB);
  static const lightError = Color(0xFF4D1717);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightOnBackground = Color(0xFF1A1A1A);
  static const lightOnSurface = Color(0xFF212121);

  // ── Gaming Theme ──
  static const gamingPrimary = Color(0xFF00E676);
  static const gamingSecondary = Color(0xFF76FF03);
  static const gamingBackground = Color(0xFF0A0A0A);
  static const gamingSurface = Color(0xFF1A1A2E);
  static const gamingError = Color(0xFFFF1744);
  static const gamingOnPrimary = Color(0xFF000000);
  static const gamingOnBackground = Color(0xFFE0E0E0);
  static const gamingOnSurface = Color(0xFFE0E0E0);
  static const gamingAccent = Color(0xFF00E5FF);

  // ── Pastel Theme ──
  static const pastelPrimary = Color(0xFFE91E63);
  static const pastelSecondary = Color(0xFFF48FB1);
  static const pastelBackground = Color(0xFFFFF0F5);
  static const pastelSurface = Color(0xFFFFFFFF);
  static const pastelError = Color(0xFFD32F2F);
  static const pastelOnPrimary = Color(0xFFFFFFFF);
  static const pastelOnBackground = Color(0xFF424242);
  static const pastelOnSurface = Color(0xFF424242);

  // ── Semantic Colors (shared) ──
  static const streakFire = Color(0xFFFF6D00);
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF39C12);
  static const info = Color(0xFF3498DB);
  static const badgeGold = Color(0xFFFFD700);
  static const progressGreen = Color(0xFF2ECC71);
  static const progressYellow = Color(0xFFF1C40F);
  static const progressRed = Color(0xFFE74C3C);

  // ── Chart gradients ──
  static const chartGreenStart = Color(0xFF2ECC71);
  static const chartGreenEnd = Color(0xFF174D38);
  static const chartRedStart = Color(0xFFE74C3C);
  static const chartRedEnd = Color(0xFF4D1717);

  // ── Neumorphism helpers ──
  static Color neumorphShadowDark(Brightness brightness) =>
      brightness == Brightness.dark
          ? const Color(0xFF061410)
          : const Color(0xFFA3A3A3);

  static Color neumorphShadowLight(Brightness brightness) =>
      brightness == Brightness.dark
          ? const Color(0xFF1A3829)
          : const Color(0xFFFFFFFF);
}
