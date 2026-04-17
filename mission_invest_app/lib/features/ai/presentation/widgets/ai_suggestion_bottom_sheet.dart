import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_button.dart';

class AiSuggestionBottomSheet extends StatelessWidget {
  final String suggestion;
  final String reasoning;
  final VoidCallback? onAccept;

  const AiSuggestionBottomSheet({
    super.key,
    required this.suggestion,
    required this.reasoning,
    this.onAccept,
  });

  static void show(BuildContext context, {required String suggestion, required String reasoning, VoidCallback? onAccept}) {
    showModalBottomSheet(
      context: context,
      builder: (_) => AiSuggestionBottomSheet(suggestion: suggestion, reasoning: reasoning, onAccept: onAccept),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.smart_toy, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('AI Recommendation', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(suggestion, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(reasoning, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(153))),
            const SizedBox(height: 24),
            AppButton(
              label: onAccept != null ? 'Apply Suggestion' : 'Got it',
              onPressed: onAccept ?? () => Navigator.pop(context),
            ),
            if (onAccept != null) ...[
              const SizedBox(height: 8),
              Center(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Not now'))),
            ],
          ],
        ),
      ),
    );
  }
}
