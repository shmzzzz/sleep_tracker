import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/utils/time_utils.dart';

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

    if (filtered.length <= 1) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
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
    final minY = ((yValues.reduce((a, b) => a < b ? a : b) - 0.5).clamp(0, 24))
        .toDouble();
    final maxY = ((yValues.reduce((a, b) => a > b ? a : b) + 0.5).clamp(0, 24))
        .toDouble();

    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, right: 12, left: 6, bottom: 8),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,
                  getTitlesWidget: (value, _) =>
                      Text('${value.toStringAsFixed(0)}h'),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 32,
                  getTitlesWidget: (value, _) {
                    final label = labels[value.toInt()];
                    if (label == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
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
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(
                strokeWidth: 0.4,
                color: colorScheme.outlineVariant.withOpacity(0.4),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: colorScheme.outlineVariant),
                bottom: BorderSide(color: colorScheme.outlineVariant),
                top: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.4)),
                right: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.4)),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 3,
                color: colorScheme.primary,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: colorScheme.primaryContainer.withOpacity(0.35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
