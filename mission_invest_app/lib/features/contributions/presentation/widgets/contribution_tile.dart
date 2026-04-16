import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';

class ContributionTile extends StatelessWidget {
  final double amount;
  final DateTime date;
  final int streakDay;
  final String? note;

  const ContributionTile({
    super.key,
    required this.amount,
    required this.date,
    required this.streakDay,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          'D$streakDay',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      title: Text(
        CurrencyFormatter.format(amount),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(note ?? AppDateUtils.formatDate(date)),
      trailing: Text(
        AppDateUtils.formatShort(date),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
