import 'package:flutter/material.dart';
import 'package:sleep_tracker/utils/time_utils.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

class SleepEntryPreviewCard extends StatelessWidget {
  const SleepEntryPreviewCard({
    super.key,
    required this.total,
    required this.goal,
    required this.achievedIcon,
    required this.unachievedIcon,
    required this.achievedColor,
    required this.unachievedColor,
    required this.emptyStateText,
    required this.achievedText,
    required this.unachievedText,
    this.createdAtLabel,
  });

  final String total;
  final String goal;
  final IconData achievedIcon;
  final IconData unachievedIcon;
  final Color achievedColor;
  final Color unachievedColor;
  final String emptyStateText;
  final String achievedText;
  final String unachievedText;
  final String? createdAtLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalDuration = hmToDuration(total);
    final goalDuration = hmToDuration(goal);
    final bool hasEnoughData = totalDuration != null && goalDuration != null;
    final difference = hasEnoughData
        ? formatDurationDifference(totalDuration - goalDuration)
        : '--';
    final achieved = hasEnoughData && totalDuration >= goalDuration;

    final statusText = !hasEnoughData
        ? emptyStateText
        : achieved
            ? achievedText
            : unachievedText;

    final statusColor = achieved ? achievedColor : unachievedColor;
    final statusIcon = achieved ? achievedIcon : unachievedIcon;

    return Container(
      padding: UiConstants.sleepFormPreviewPadding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
            BorderRadius.circular(UiConstants.sleepFormPreviewCornerRadius),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withOpacity(UiConstants.sleepFormPreviewShadowOpacity),
            blurRadius: UiConstants.sleepFormPreviewShadowBlur,
            offset: UiConstants.sleepFormPreviewShadowOffset,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: UiConstants.sleepFormPreviewStatusIconSize,
              ),
              const SizedBox(width: UiConstants.sleepFormPreviewStatusSpacing),
              Expanded(
                child: Text(
                  statusText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: UiConstants.sleepFormPreviewMetricsSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PreviewMetric(
                label: '合計睡眠',
                value: total.isEmpty ? '--:--' : total,
                color: colorScheme.primary,
              ),
              _PreviewMetric(
                label: '目標',
                value: goal.isEmpty ? '--:--' : goal,
                color: colorScheme.secondary,
              ),
              _PreviewMetric(
                label: '差分',
                value: difference,
                color: statusColor,
              ),
            ],
          ),
          if (createdAtLabel != null) ...[
            const SizedBox(height: UiConstants.sleepFormPreviewMetricsSpacing),
            Text(
              createdAtLabel!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withOpacity(UiConstants.sleepFormMetricLabelOpacity),
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: UiConstants.sleepFormMetricSpacing),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}
