import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/utils/time_utils.dart';

const _emptyStatePadding = EdgeInsets.symmetric(vertical: 16);
const _minDataPoints = 2;
const _chartAspectRatio = 1.5;
const _chartPadding = EdgeInsets.only(top: 12, right: 12, left: 6, bottom: 8);
const _yAxisPadding = 0.5;
const _maxHoursPerDay = 24;
const _leftTitleReservedSize = 44.0;
const _bottomTitleReservedSize = 32.0;
const _bottomTitleSpacing = 8.0;
const _gridInterval = 1.0;
const _gridStrokeWidth = 0.7;
const _gridDashArray = [4, 4];
const _gridLineOpacity = 0.6;
const _axisLineOpacity = 0.4;
const _lineBarWidth = 3.0;
const _dotRadius = 3.2;
const _dotStrokeWidth = 1.6;
const _areaOpacityStart = 0.2;
const _areaOpacityEnd = 0.02;

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

    if (filtered.length < _minDataPoints) {
      return const Padding(
        padding: _emptyStatePadding,
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
    final minY = ((yValues.reduce((a, b) => a < b ? a : b) - _yAxisPadding)
            .clamp(0, _maxHoursPerDay))
        .toDouble();
    final maxY = ((yValues.reduce((a, b) => a > b ? a : b) + _yAxisPadding)
            .clamp(0, _maxHoursPerDay))
        .toDouble();

    final colorScheme = Theme.of(context).colorScheme;
    final gridLineColor = colorScheme.outlineVariant.withOpacity(_gridLineOpacity);
    final axisLineColor = colorScheme.outlineVariant;

    return AspectRatio(
      aspectRatio: _chartAspectRatio,
      child: Padding(
        padding: _chartPadding,
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: _leftTitleReservedSize,
                  getTitlesWidget: (value, _) =>
                      Text('${value.toStringAsFixed(0)}h'),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: _gridInterval,
                  reservedSize: _bottomTitleReservedSize,
                  getTitlesWidget: (value, _) {
                    final label = labels[value.toInt()];
                    if (label == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: _bottomTitleSpacing),
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
              horizontalInterval: _gridInterval,
              getDrawingHorizontalLine: (value) => FlLine(
                strokeWidth: _gridStrokeWidth,
                dashArray: _gridDashArray,
                color: gridLineColor,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: axisLineColor),
                bottom: BorderSide(color: axisLineColor),
                top: BorderSide(
                    color: axisLineColor.withOpacity(_axisLineOpacity)),
                right: BorderSide(
                    color: axisLineColor.withOpacity(_axisLineOpacity)),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: _lineBarWidth,
                color: colorScheme.primary,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: _dotRadius,
                      color: colorScheme.primary,
                      strokeWidth: _dotStrokeWidth,
                      strokeColor: colorScheme.surface,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(_areaOpacityStart),
                      colorScheme.primary.withOpacity(_areaOpacityEnd),
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
