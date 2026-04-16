import 'package:flutter/material.dart';
import '../../../../shared/widgets/dashboard_card.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.colorScheme.primary;

    return KpiCard(
      title: title,
      value: value,
      icon: icon,
      color: iconColor,
    );
  }
}
