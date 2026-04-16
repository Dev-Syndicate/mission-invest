import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickContributeButton extends StatelessWidget {
  final String missionId;
  final String missionTitle;
  final double dailyTarget;
  final VoidCallback? onPressed;

  const QuickContributeButton({
    super.key,
    required this.missionId,
    required this.missionTitle,
    required this.dailyTarget,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed ??
          () => context.pushNamed(
                'logContribution',
                pathParameters: {'missionId': missionId},
              ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, size: 16),
          const SizedBox(width: 4),
          Text(
            '\u20B9${dailyTarget.toInt()}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
