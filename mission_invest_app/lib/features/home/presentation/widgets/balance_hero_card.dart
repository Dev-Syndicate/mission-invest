import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Hero balance card with total savings, weekly growth, and a sparkline.
class BalanceHeroCard extends StatelessWidget {
  final double totalSaved;
  final double weeklyGrowth;
  final List<double> recentAmounts;

  const BalanceHeroCard({
    super.key,
    required this.totalSaved,
    required this.weeklyGrowth,
    required this.recentAmounts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF174D38), const Color(0xFF0F3426)]
              : [const Color(0xFF174D38), const Color(0xFF1E6B4E)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withAlpha(isDark ? 80 : 50),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Savings',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(180),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: weeklyGrowth >= 0
                          ? Colors.white.withAlpha(20)
                          : AppColors.expense.withAlpha(40),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          weeklyGrowth >= 0
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          size: 14,
                          color: weeklyGrowth >= 0
                              ? AppColors.chartGreenStart
                              : const Color(0xFFFF6B6B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${weeklyGrowth >= 0 ? '+' : ''}${weeklyGrowth.toStringAsFixed(1)}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: weeklyGrowth >= 0
                                ? AppColors.chartGreenStart
                                : const Color(0xFFFF6B6B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                CurrencyFormatter.format(totalSaved),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'this week',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(130),
                ),
              ),
              if (recentAmounts.length >= 2) ...[
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: _SparkLine(data: recentAmounts),
                ),
              ],
            ],
          ),
    );
  }
}

class _SparkLine extends StatelessWidget {
  final List<double> data;

  const _SparkLine({required this.data});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i]));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: Colors.white.withAlpha(200),
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withAlpha(40),
                  Colors.white.withAlpha(5),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 800),
    );
  }
}
