import 'package:flutter/material.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/utils/sleep_statistics.dart';
import 'package:sleep_tracker/widgets/statistics/sleep_trend_chart.dart';

class SleepStatisticsOverview extends StatelessWidget {
  const SleepStatisticsOverview({
    super.key,
    required this.statistics,
    required this.entries,
  });

  final SleepStatistics statistics;
  final List<SleepEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text(
            '睡眠インサイト',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '最近の概要',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MetricChip(
                      label: '平均睡眠',
                      value: statistics.averageTotalText(),
                      color: colorScheme.primaryContainer,
                      textColor: colorScheme.onPrimaryContainer,
                    ),
                    _MetricChip(
                      label: '平均コア',
                      value: statistics.averageCoreText(),
                      color: colorScheme.secondaryContainer,
                      textColor: colorScheme.onSecondaryContainer,
                    ),
                    _MetricChip(
                      label: '最高睡眠',
                      value: statistics.bestTotalText(),
                      color: colorScheme.tertiaryContainer,
                      textColor: colorScheme.onTertiaryContainer,
                    ),
                    _MetricChip(
                      label: '目標達成率',
                      value: statistics.achievementRateText(),
                      color: colorScheme.primary,
                      textColor: colorScheme.onPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '睡眠トレンド',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                SleepTrendChart(entries: entries),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
