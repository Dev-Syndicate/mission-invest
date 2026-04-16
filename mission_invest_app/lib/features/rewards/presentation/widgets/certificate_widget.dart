import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/currency_formatter.dart';

class CertificateWidget extends StatelessWidget {
  final String missionTitle;
  final double amountSaved;
  final int daysTaken;
  final DateTime completedAt;

  const CertificateWidget({
    super.key,
    required this.missionTitle,
    required this.amountSaved,
    required this.daysTaken,
    required this.completedAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatted = DateFormat.yMMMMd().format(completedAt);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: Colors.amber, width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
          const SizedBox(height: 16),
          Text(
            'Mission Complete!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Certificate of Achievement',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(153),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Text('Mission: $missionTitle',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text('Amount Saved: ${CurrencyFormatter.format(amountSaved)}',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text('Days Taken: $daysTaken',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text('Completed: $dateFormatted',
              style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}
