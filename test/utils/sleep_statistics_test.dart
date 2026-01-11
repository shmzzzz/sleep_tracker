import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/utils/sleep_statistics.dart';

void main() {
  group('SleepStatistics.fromEntries', () {
    test('returns empty statistics for no entries', () {
      final stats = SleepStatistics.fromEntries([]);

      expect(stats.totalCount, 0);
      expect(stats.achievedCount, 0);
      expect(stats.averageTotal, isNull);
      expect(stats.averageCore, isNull);
      expect(stats.bestTotal, isNull);
      expect(stats.hasSleepData, isFalse);
      expect(stats.achievementRate, 0);
      expect(stats.achievementRateText(), '0%');
    });

    test('calculates averages and best total', () {
      final entries = [
        _entry(
          total: '7:00',
          core: '5:00',
          isAchieved: true,
        ),
        _entry(
          total: '8:30',
          core: '6:00',
          isAchieved: true,
        ),
        _entry(
          total: '6:30',
          core: '4:30',
          isAchieved: false,
        ),
      ];

      final stats = SleepStatistics.fromEntries(entries);

      expect(stats.totalCount, 3);
      expect(stats.achievedCount, 2);
      expect(stats.averageTotal, const Duration(hours: 7, minutes: 20));
      expect(stats.averageCore, const Duration(hours: 5, minutes: 10));
      expect(stats.bestTotal, const Duration(hours: 8, minutes: 30));
      expect(stats.hasSleepData, isTrue);
      expect(stats.achievementRateText(), '67%');
      expect(stats.averageTotalText(), '7時間20分');
      expect(stats.averageCoreText(), '5時間10分');
      expect(stats.bestTotalText(), '8時間30分');
    });
  });
}

SleepEntry _entry({
  required String total,
  required String core,
  required bool isAchieved,
}) {
  return SleepEntry(
    id: 'id',
    total: total,
    sleep: total,
    core: core,
    goal: '7:00',
    isAchieved: isAchieved,
    createdAt: DateTime(2024, 1, 1),
  );
}
