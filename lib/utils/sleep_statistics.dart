import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/utils/time_utils.dart';

class SleepStatistics {
  SleepStatistics({
    required this.totalCount,
    required this.achievedCount,
    required this.averageTotal,
    required this.averageCore,
    required this.bestTotal,
  });

  final int totalCount;
  final int achievedCount;
  final Duration? averageTotal;
  final Duration? averageCore;
  final Duration? bestTotal;

  double get achievementRate {
    if (totalCount == 0) {
      return 0;
    }
    return achievedCount / totalCount;
  }

  bool get hasSleepData => averageTotal != null || bestTotal != null;

  factory SleepStatistics.fromEntries(List<SleepEntry> entries) {
    if (entries.isEmpty) {
      return SleepStatistics.empty();
    }

    final totalDurations = entries
        .map((entry) => entry.totalDuration)
        .whereType<Duration>()
        .toList(growable: false);
    final coreDurations = entries
        .map((entry) => entry.coreDuration)
        .whereType<Duration>()
        .toList(growable: false);

    Duration? average(List<Duration> durations) {
      if (durations.isEmpty) {
        return null;
      }
      final totalMinutes =
          durations.fold<int>(0, (sum, duration) => sum + duration.inMinutes);
      return Duration(minutes: (totalMinutes / durations.length).round());
    }

    Duration? best(List<Duration> durations) {
      if (durations.isEmpty) {
        return null;
      }
      return durations.reduce(
        (current, next) => current >= next ? current : next,
      );
    }

    final achievedCount = entries.where((entry) => entry.isAchieved).length;

    return SleepStatistics(
      totalCount: entries.length,
      achievedCount: achievedCount,
      averageTotal: average(totalDurations),
      averageCore: average(coreDurations),
      bestTotal: best(totalDurations),
    );
  }

  factory SleepStatistics.empty() {
    return SleepStatistics(
      totalCount: 0,
      achievedCount: 0,
      averageTotal: null,
      averageCore: null,
      bestTotal: null,
    );
  }

  String averageTotalText() => formatDurationInJapanese(averageTotal);

  String averageCoreText() => formatDurationInJapanese(averageCore);

  String bestTotalText() => formatDurationInJapanese(bestTotal);

  String achievementRateText() {
    final percentage = (achievementRate * 100).round();
    return '$percentage%';
  }
}
