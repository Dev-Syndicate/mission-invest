import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A premium neumorphic card with optional gradient border and glass effect.
class DashboardCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Gradient? gradient;
  final bool glassEffect;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? borderColor;

  const DashboardCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.gradient,
    this.glassEffect = false,
    this.borderRadius = 20,
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surface = Theme.of(context).colorScheme.surface;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? surface : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : Border.all(
                color: brightness == Brightness.dark
                    ? Colors.white.withAlpha(8)
                    : Colors.black.withAlpha(8),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neumorphShadowDark(brightness),
            offset: const Offset(4, 4),
            blurRadius: 12,
          ),
          BoxShadow(
            color: AppColors.neumorphShadowLight(brightness),
            offset: const Offset(-2, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: glassEffect
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(20),
                  child: child,
                ),
              ),
            )
          : Padding(
              padding: padding ?? const EdgeInsets.all(20),
              child: child,
            ),
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

/// A compact KPI stat card for admin dashboards.
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool trendUp;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.trendUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (trend != null) ...[
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendUp
                        ? AppColors.success.withAlpha(20)
                        : AppColors.progressRed.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 12,
                        color: trendUp
                            ? AppColors.success
                            : AppColors.progressRed,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: trendUp
                              ? AppColors.success
                              : AppColors.progressRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(120),
            ),
          ),
        ],
      ),
    );
  }
}

/// An animated progress bar used across dashboards.
class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.backgroundColor,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? theme.colorScheme.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return LinearProgressIndicator(
            value: value,
            minHeight: height,
            backgroundColor:
                backgroundColor ?? progressColor.withAlpha(25),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          );
        },
      ),
    );
  }
}
