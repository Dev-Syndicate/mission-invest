import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/display_mode.dart';

/// A toggle switch widget for switching between Win and Focus display modes.
///
/// Win mode: celebrations, confetti, party vibes.
/// Focus mode: clean, minimal, zen-like.
class DisplayModeToggle extends ConsumerWidget {
  const DisplayModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(displayModeProvider);
    final isWin = mode == DisplayMode.win;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => ref.read(displayModeProvider.notifier).toggle(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isWin
              ? Colors.amber.withAlpha(30)
              : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isWin
                ? Colors.amber.withAlpha(127)
                : theme.dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                isWin ? Icons.celebration : Icons.self_improvement,
                key: ValueKey(isWin),
                size: 20,
                color: isWin ? Colors.amber : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isWin ? 'Win' : 'Focus',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isWin ? Colors.amber : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      )
          .animate(target: isWin ? 1.0 : 0.0)
          .shimmer(
            duration: 1500.ms,
            color: Colors.amber.withAlpha(isWin ? 40 : 0),
          ),
    );
  }
}
