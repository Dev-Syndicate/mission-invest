import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber, width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
          const SizedBox(height: 12),
          Text(
            'Certificate of Achievement',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          Text('Mission: $missionTitle'),
          Text(
            'Amount Saved: \u20B9${amountSaved.toStringAsFixed(0)}',
          ),
          Text('Completed in: $daysTaken days'),
        ],
      ),
    );
  }
}
