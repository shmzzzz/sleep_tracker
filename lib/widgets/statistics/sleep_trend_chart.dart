import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/utils/time_utils.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

class SleepTrendChart extends StatelessWidget {
  const SleepTrendChart({
    super.key,
    required this.entries,
  });

  final List<SleepEntry> entries;

  @override
  Widget build(BuildContext context) {
    final filtered = entries
        .where((entry) => entry.totalDuration != null)
        .toList(growable: false)
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (filtered.length < UiConstants.trendChartMinDataPoints) {
      return const Padding(
        padding: UiConstants.trendChartEmptyStatePadding,
        child: Center(
          child: Text('グラフを表示するには睡眠データを2日以上登録してください。'),
        ),
      );
    }

    final spots = <FlSpot>[];
    final labels = <int, String>{};
    for (var index = 0; index < filtered.length; index++) {
      final entry = filtered[index];
      final totalDuration = entry.totalDuration!;
      final hours = totalDuration.inMinutes / 60;
      spots.add(FlSpot(index.toDouble(), hours));
      labels[index] = formatDayLabel(entry.createdAt);
    }

    final yValues = spots.map((spot) => spot.y);
    final minY = ((yValues.reduce((a, b) => a < b ? a : b) -
                UiConstants.trendChartYAxisPadding)
            .clamp(0, UiConstants.trendChartMaxHoursPerDay))
        .toDouble();
    final maxY = ((yValues.reduce((a, b) => a > b ? a : b) +
                UiConstants.trendChartYAxisPadding)
            .clamp(0, UiConstants.trendChartMaxHoursPerDay))
        .toDouble();

    final colorScheme = Theme.of(context).colorScheme;
    final gridLineColor = colorScheme.outlineVariant
        .withOpacity(UiConstants.trendChartGridLineOpacity);
    final axisLineColor = colorScheme.outlineVariant;

    return AspectRatio(
      aspectRatio: UiConstants.trendChartAspectRatio,
      child: Padding(
        padding: UiConstants.trendChartPadding,
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: UiConstants.trendChartLeftTitleReservedSize,
                  getTitlesWidget: (value, _) =>
                      Text('${value.toStringAsFixed(0)}h'),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: UiConstants.trendChartGridInterval,
                  reservedSize: UiConstants.trendChartBottomTitleReservedSize,
                  getTitlesWidget: (value, _) {
                    final label = labels[value.toInt()];
                    if (label == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: UiConstants.trendChartBottomTitleSpacing),
                      child: Text(label),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: UiConstants.trendChartGridInterval,
              getDrawingHorizontalLine: (value) => FlLine(
                strokeWidth: UiConstants.trendChartGridStrokeWidth,
                dashArray: UiConstants.trendChartGridDashArray,
                color: gridLineColor,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: axisLineColor),
                bottom: BorderSide(color: axisLineColor),
                top: BorderSide(
                    color: axisLineColor
                        .withOpacity(UiConstants.trendChartAxisLineOpacity)),
                right: BorderSide(
                    color: axisLineColor
                        .withOpacity(UiConstants.trendChartAxisLineOpacity)),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: UiConstants.trendChartLineBarWidth,
                color: colorScheme.primary,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: UiConstants.trendChartDotRadius,
                      color: colorScheme.primary,
                      strokeWidth: UiConstants.trendChartDotStrokeWidth,
                      strokeColor: colorScheme.surface,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary
                          .withOpacity(UiConstants.trendChartAreaOpacityStart),
                      colorScheme.primary
                          .withOpacity(UiConstants.trendChartAreaOpacityEnd),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
