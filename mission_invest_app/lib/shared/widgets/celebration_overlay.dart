import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/display_mode.dart';

/// A widget that shows celebration effects (confetti, sparkles) only in Win mode.
///
/// In Focus mode, it simply renders the [child] with no animation.
/// Pass [trigger] = true to fire the celebration animation.
class CelebrationOverlay extends ConsumerStatefulWidget {
  final Widget child;
  final bool trigger;

  const CelebrationOverlay({
    super.key,
    required this.child,
    this.trigger = false,
  });

  @override
  ConsumerState<CelebrationOverlay> createState() =>
      _CelebrationOverlayState();
}

class _CelebrationOverlayState extends ConsumerState<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _controller.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _fireCelebration();
    }
  }

  void _fireCelebration() {
    final mode = ref.read(displayModeProvider);
    if (mode != DisplayMode.win) return;

    _particles.clear();
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: 0.3 + _random.nextDouble() * 0.2,
        vx: (_random.nextDouble() - 0.5) * 2,
        vy: -2 - _random.nextDouble() * 3,
        color: _confettiColors[_random.nextInt(_confettiColors.length)],
        size: 4 + _random.nextDouble() * 6,
      ));
    }
    _controller.forward(from: 0);
  }

  static const _confettiColors = [
    Colors.amber,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.cyan,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(displayModeProvider);
    final isWin = mode == DisplayMode.win;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main child content
        widget.child,

        // Particle overlay (Win mode only)
        if (isWin && _controller.isAnimating && _particles.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              ),
            ),
          ),

        // Subtle glow pulse on trigger in Win mode
        if (isWin && widget.trigger)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
              )
                  .animate(
                    onPlay: (c) => c.forward(),
                    autoPlay: true,
                  )
                  .custom(
                    duration: 600.ms,
                    builder: (context, value, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                Colors.amber.withAlpha((80 * (1 - value)).round()),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ),
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double size;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final gravity = 5.0;

    for (final p in particles) {
      final t = progress;
      final px = (p.x + p.vx * t * 0.1) * size.width;
      final py = (p.y + p.vy * t * 0.1 + gravity * t * t * 0.05) * size.height;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = p.color.withAlpha((255 * opacity).round())
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(px, py), p.size * (1.0 - progress * 0.3), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
