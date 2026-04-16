import 'package:flutter/material.dart';

class AiNudgeCard extends StatelessWidget {
  final String message;
  final String? actionSuggestion;
  final VoidCallback? onAccept;
  final VoidCallback? onDismiss;

  const AiNudgeCard({
    super.key,
    required this.message,
    this.actionSuggestion,
    this.onAccept,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.smart_toy, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('AI Suggestion', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(message),
            if (actionSuggestion != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onAccept != null)
                    FilledButton.tonal(onPressed: onAccept, child: const Text('Accept')),
                  const SizedBox(width: 8),
                  if (onDismiss != null)
                    TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
