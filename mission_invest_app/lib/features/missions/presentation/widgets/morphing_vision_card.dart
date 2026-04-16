import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_colors.dart';

/// Morph stages tied to progress percentage.
enum MorphStage {
  sketch,      // 0–24%
  takingShape, // 25–49%
  almostThere, // 50–74%
  revealed,    // 75–99%
  complete,    // 100%
}

class MorphStageHelper {
  MorphStageHelper._();

  static MorphStage fromProgress(double progress) {
    if (progress >= 1.0) return MorphStage.complete;
    if (progress >= 0.75) return MorphStage.revealed;
    if (progress >= 0.50) return MorphStage.almostThere;
    if (progress >= 0.25) return MorphStage.takingShape;
    return MorphStage.sketch;
  }

  static String label(MorphStage stage) {
    return switch (stage) {
      MorphStage.sketch => 'Sketch',
      MorphStage.takingShape => 'Taking Shape',
      MorphStage.almostThere => 'Almost There',
      MorphStage.revealed => 'Revealed!',
      MorphStage.complete => 'Complete!',
    };
  }

  /// Saturation value: 0.0 = greyscale, 1.0 = full color.
  static double saturation(MorphStage stage) {
    return switch (stage) {
      MorphStage.sketch => 0.0,
      MorphStage.takingShape => 0.4,
      MorphStage.almostThere => 1.0,
      MorphStage.revealed => 1.0,
      MorphStage.complete => 1.0,
    };
  }

  /// Blur sigma value.
  static double blurSigma(MorphStage stage) {
    return switch (stage) {
      MorphStage.sketch => 8.0,
      MorphStage.takingShape => 4.0,
      MorphStage.almostThere => 1.5,
      MorphStage.revealed => 0.0,
      MorphStage.complete => 0.0,
    };
  }
}

/// A vision card that visually transforms as the user's save progress increases.
class MorphingVisionCard extends StatelessWidget {
  final String? visionImageUrl;
  final double progressPercentage;
  final String? category;

  const MorphingVisionCard({
    super.key,
    this.visionImageUrl,
    required this.progressPercentage,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final stage = MorphStageHelper.fromProgress(progressPercentage);
    final saturation = MorphStageHelper.saturation(stage);
    final blur = MorphStageHelper.blurSigma(stage);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: saturation, end: saturation),
      duration: const Duration(milliseconds: 600),
      builder: (context, animSaturation, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: blur, end: blur),
          duration: const Duration(milliseconds: 600),
          builder: (context, animBlur, _) {
            return _MorphCardContent(
              visionImageUrl: visionImageUrl,
              category: category,
              saturation: animSaturation,
              blur: animBlur,
              stage: stage,
              progress: progressPercentage,
            );
          },
        );
      },
    );
  }
}

class _MorphCardContent extends StatelessWidget {
  final String? visionImageUrl;
  final String? category;
  final double saturation;
  final double blur;
  final MorphStage stage;
  final double progress;

  const _MorphCardContent({
    required this.visionImageUrl,
    this.category,
    required this.saturation,
    required this.blur,
    required this.stage,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isComplete = stage == MorphStage.complete;
    final bool isRevealed = stage == MorphStage.revealed;

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: (isRevealed || isComplete)
            ? Border.all(
                color: isComplete
                    ? AppColors.badgeGold
                    : theme.colorScheme.primary,
                width: isComplete ? 2.5 : 1.5,
              )
            : null,
        boxShadow: isRevealed || isComplete
            ? [
                BoxShadow(
                  color: isComplete
                      ? AppColors.badgeGold.withAlpha(76)
                      : theme.colorScheme.primary.withAlpha(51),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          (isRevealed || isComplete) ? 14 : 16,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image layer with color + blur filters
            _buildImage(context),

            // Morph stage label overlay
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  MorphStageHelper.label(stage),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Celebration overlay at 100%
            if (isComplete)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.badgeGold.withAlpha(38),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.celebration,
                    size: 48,
                    color: AppColors.badgeGold.withAlpha(178),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    // Shimmer/glow animation for completed missions
    if (isComplete) {
      card = card
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(
            duration: 2000.ms,
            color: AppColors.badgeGold.withAlpha(51),
          );
    }

    return card;
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);

    Widget imageWidget;

    if (visionImageUrl != null && visionImageUrl!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: visionImageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (_, _) => Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, _, _) => _buildPlaceholder(context),
      );
    } else {
      imageWidget = _buildPlaceholder(context);
    }

    // Apply saturation via ColorFiltered
    final satMatrix = _saturationMatrix(saturation);
    Widget filtered = ColorFiltered(
      colorFilter: ColorFilter.matrix(satMatrix),
      child: imageWidget,
    );

    // Apply blur via ImageFiltered
    if (blur > 0.01) {
      filtered = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
          tileMode: TileMode.decal,
        ),
        child: filtered,
      );
    }

    return filtered;
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final emoji = _categoryEmoji(category);

    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              'Your Vision',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(127),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryEmoji(String? category) {
    return switch (category) {
      'trip' => '\u{2708}\u{FE0F}',
      'gadget' => '\u{1F4F1}',
      'vehicle' => '\u{1F697}',
      'emergency' => '\u{1F6D1}',
      'course' => '\u{1F393}',
      'gift' => '\u{1F381}',
      _ => '\u{1F3AF}',
    };
  }

  /// Builds a 4x5 color matrix to adjust saturation.
  /// [sat] = 0.0 for greyscale, 1.0 for original color.
  List<double> _saturationMatrix(double sat) {
    final inv = 1.0 - sat;
    final r = 0.2126 * inv;
    final g = 0.7152 * inv;
    final b = 0.0722 * inv;

    return <double>[
      r + sat, g, b, 0, 0, //
      r, g + sat, b, 0, 0, //
      r, g, b + sat, 0, 0, //
      0, 0, 0, 1, 0, //
    ];
  }
}
