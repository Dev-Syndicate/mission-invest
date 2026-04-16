import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dashboard_card.dart';

/// A bar chart widget for admin analytics dashboards.
class BarChartWidget extends StatelessWidget {
  final String title;
  final List<double> values;
  final List<String> labels;

  const BarChartWidget({
    super.key,
    required this.title,
    required this.values,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxY = values.isEmpty
        ? 10.0
        : values.reduce((a, b) => a > b ? a : b) * 1.3;

    return DashboardCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => theme.colorScheme.surface,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[idx],
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withAlpha(100),
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: values.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8)),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.chartGreenEnd,
                            AppColors.chartGreenStart,
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              duration: const Duration(milliseconds: 800),
            ),
          ),
        ],
      ),
    );
  }
}

/// A donut chart widget for category distribution.
class DonutChartWidget extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final Map<String, Color>? colorMap;

  const DonutChartWidget({
    super.key,
    required this.title,
    required this.data,
    this.colorMap,
  });

  static const _defaultColors = [
    AppColors.chartGreenStart,
    AppColors.info,
    AppColors.warning,
    AppColors.progressRed,
    AppColors.accent,
    AppColors.streakFire,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = data.values.fold<double>(0, (a, b) => a + b);

    final entries = data.entries.toList();
    final sections = entries.asMap().entries.map((entry) {
      final index = entry.key;
      final mapEntry = entry.value;
      final color = colorMap?[mapEntry.key] ??
          _defaultColors[index % _defaultColors.length];
      return PieChartSectionData(
        color: color,
        value: mapEntry.value,
        radius: 24,
        title: '',
        badgeWidget: null,
      );
    }).toList();

    return DashboardCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 36,
                    sectionsSpace: 2,
                    startDegreeOffset: -90,
                  ),
                  duration: const Duration(milliseconds: 800),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entries.asMap().entries.map((entry) {
                    final index = entry.key;
                    final mapEntry = entry.value;
                    final color = colorMap?[mapEntry.key] ??
                        _defaultColors[index % _defaultColors.length];
                    final pct = total > 0
                        ? (mapEntry.value / total * 100).toInt()
                        : 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              mapEntry.key,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withAlpha(150),
                              ),
                            ),
                          ),
                          Text(
                            '$pct%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
