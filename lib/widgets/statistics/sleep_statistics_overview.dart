import 'package:flutter/material.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/utils/sleep_statistics.dart';
import 'package:sleep_tracker/widgets/statistics/sleep_trend_chart.dart';

const _headerPadding = EdgeInsets.fromLTRB(20, 20, 20, 12);
const _panelMargin = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
const _panelPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 18);
const _panelCornerRadius = 20.0;
const _panelSpacing = 12.0;
const _panelGradientOpacity = 0.65;
const _metricChipSpacing = 12.0;
const _chartPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);
const _chartCornerRadius = 20.0;
const _chartTitlePadding = EdgeInsets.symmetric(horizontal: 8);
const _chipPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
const _chipCornerRadius = 16.0;
const _chipDotSize = 8.0;
const _chipDotSpacing = 6.0;
const _chipValueSpacing = 4.0;
const _chipLabelLetterSpacing = 0.1;
const _chipBackgroundOpacity = 0.14;
const _chipBorderOpacity = 0.35;

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
        colorScheme.surfaceVariant.withOpacity(_panelGradientOpacity),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: _headerPadding,
          child: Text(
            '睡眠インサイト',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          margin: _panelMargin,
          padding: _panelPadding,
          decoration: BoxDecoration(
            gradient: panelGradient,
            borderRadius: BorderRadius.circular(_panelCornerRadius),
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
              const SizedBox(height: _panelSpacing),
              Wrap(
                spacing: _metricChipSpacing,
                runSpacing: _metricChipSpacing,
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
          margin: _panelMargin,
          padding: _chartPadding,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(_chartCornerRadius),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: _chartTitlePadding,
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
      padding: _chipPadding,
      decoration: BoxDecoration(
        color: color.withOpacity(_chipBackgroundOpacity),
        borderRadius: BorderRadius.circular(_chipCornerRadius),
        border: Border.all(color: color.withOpacity(_chipBorderOpacity)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: _chipDotSize,
                height: _chipDotSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: _chipDotSpacing),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: _chipLabelLetterSpacing,
                    ),
              ),
            ],
          ),
          const SizedBox(height: _chipValueSpacing),
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
