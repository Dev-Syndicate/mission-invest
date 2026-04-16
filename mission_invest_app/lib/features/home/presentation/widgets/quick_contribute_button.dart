import 'package:flutter/material.dart';

class QuickContributeButton extends StatelessWidget {
  final String missionTitle;
  final double dailyTarget;
  final VoidCallback? onPressed;

  const QuickContributeButton({
    super.key,
    required this.missionTitle,
    required this.dailyTarget,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, size: 18),
          const SizedBox(width: 4),
          Text(
            '\u20B9${dailyTarget.toInt()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
