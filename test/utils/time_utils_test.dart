import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_tracker/utils/time_utils.dart';

void main() {
  group('normalizeFlexibleHm', () {
    test('normalizes various formats', () {
      expect(normalizeFlexibleHm('7'), '07:00');
      expect(normalizeFlexibleHm('7:3'), '07:03');
      expect(normalizeFlexibleHm('07:30'), '07:30');
      expect(normalizeFlexibleHm('7.5'), '07:30');
      expect(normalizeFlexibleHm('24:00'), '24:00');
    });

    test('returns null for invalid values', () {
      expect(normalizeFlexibleHm(''), isNull);
      expect(normalizeFlexibleHm('30:00'), isNull);
      expect(normalizeFlexibleHm('7:99'), isNull);
      expect(normalizeFlexibleHm('abc'), isNull);
    });
  });

  group('normalizeFlexibleHmRange', () {
    test('normalizes ranges', () {
      expect(normalizeFlexibleHmRange('7-8'), '07:00-08:00');
      expect(normalizeFlexibleHmRange('7〜8'), '07:00-08:00');
      expect(normalizeFlexibleHmRange('7:30 - 9'), '07:30-09:00');
    });

    test('returns null for invalid ranges', () {
      expect(normalizeFlexibleHmRange('7-'), isNull);
      expect(normalizeFlexibleHmRange('7-30:00'), isNull);
    });
  });

  test('parseHm throws on invalid format', () {
    expect(() => parseHm('abc'), throwsFormatException);
  });

  test('hmToDuration converts normalized values', () {
    expect(hmToDuration('7:05'), const Duration(hours: 7, minutes: 5));
    expect(hmToDuration('7.5'), const Duration(hours: 7, minutes: 30));
    expect(hmToDuration('abc'), isNull);
  });

  test('formatDurationInJapanese formats as expected', () {
    expect(formatDurationInJapanese(null), '--');
    expect(
      formatDurationInJapanese(const Duration(hours: 7, minutes: 30)),
      '7時間30分',
    );
    expect(formatDurationInJapanese(const Duration(minutes: 45)), '45分');
  });

  test('formatDurationDifference formats signed values', () {
    expect(formatDurationDifference(Duration.zero), '±0分');
    expect(
      formatDurationDifference(const Duration(hours: 1, minutes: 30)),
      '+1時間30分',
    );
    expect(formatDurationDifference(const Duration(minutes: -30)), '-30分');
  });

  test('isAchievedByHm compares total and goal', () {
    expect(isAchievedByHm('7:00', '6:30'), isTrue);
    expect(isAchievedByHm('6:00', '6:30'), isFalse);
    expect(isAchievedByHm('abc', '6:30'), isFalse);
  });
}
