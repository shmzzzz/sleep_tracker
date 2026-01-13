import 'package:flutter/material.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/utils/sleep_statistics.dart';
import 'package:sleep_tracker/widgets/statistics/sleep_trend_chart.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

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
    final panelGradient = LinearGradient(
      colors: [
        colorScheme.surface,
        colorScheme.surfaceVariant
            .withOpacity(UiConstants.statisticsPanelGradientOpacity),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: UiConstants.statisticsHeaderPadding,
          child: Text(
            '睡眠インサイト',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          margin: UiConstants.statisticsPanelMargin,
          padding: UiConstants.statisticsPanelPadding,
          decoration: BoxDecoration(
            gradient: panelGradient,
            borderRadius:
                BorderRadius.circular(UiConstants.statisticsPanelCornerRadius),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '最近の概要',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: UiConstants.statisticsPanelSpacing),
              Wrap(
                spacing: UiConstants.statisticsMetricChipSpacing,
                runSpacing: UiConstants.statisticsMetricChipSpacing,
                children: [
                  _MetricChip(
                    label: '平均睡眠',
                    value: statistics.averageTotalText(),
                    color: colorScheme.primary,
                    textColor: colorScheme.onSurface,
                  ),
                  _MetricChip(
                    label: '平均コア',
                    value: statistics.averageCoreText(),
                    color: colorScheme.secondary,
                    textColor: colorScheme.onSurface,
                  ),
                  _MetricChip(
                    label: '最高睡眠',
                    value: statistics.bestTotalText(),
                    color: colorScheme.tertiary,
                    textColor: colorScheme.onSurface,
                  ),
                  _MetricChip(
                    label: '目標達成率',
                    value: statistics.achievementRateText(),
                    color: colorScheme.primary,
                    textColor: colorScheme.onSurface,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: UiConstants.statisticsPanelMargin,
          padding: UiConstants.statisticsChartPadding,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius:
                BorderRadius.circular(UiConstants.statisticsChartCornerRadius),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: UiConstants.statisticsChartTitlePadding,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: UiConstants.statisticsChipPadding,
      decoration: BoxDecoration(
        color: color.withOpacity(UiConstants.statisticsChipBackgroundOpacity),
        borderRadius:
            BorderRadius.circular(UiConstants.statisticsChipCornerRadius),
        border: Border.all(
            color: color.withOpacity(UiConstants.statisticsChipBorderOpacity)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: UiConstants.statisticsChipDotSize,
                height: UiConstants.statisticsChipDotSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: UiConstants.statisticsChipDotSpacing),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing:
                          UiConstants.statisticsChipLabelLetterSpacing,
                    ),
              ),
            ],
          ),
          const SizedBox(height: UiConstants.statisticsChipValueSpacing),
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
