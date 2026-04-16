import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class StreakCounter extends StatefulWidget {
  final int streak;
  final bool animate;

  const StreakCounter({
    super.key,
    required this.streak,
    this.animate = true,
  });

  @override
  State<StreakCounter> createState() => _StreakCounterState();
}

class _StreakCounterState extends State<StreakCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.animate && widget.streak > 0) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant StreakCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.streak > 0 && widget.animate) {
      _controller.repeat();
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.streak > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isActive ? _scaleAnimation.value : 1.0,
              child: child,
            );
          },
          child: Icon(
            Icons.local_fire_department,
            size: 40,
            color: isActive ? AppColors.streakFire : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.streak}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive ? AppColors.streakFire : Colors.grey,
              ),
        ),
        Text(
          'Day Streak',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
