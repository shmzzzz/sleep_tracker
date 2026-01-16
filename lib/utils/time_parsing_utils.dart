import 'package:intl/intl.dart';

const String _hmPattern = r'([0-1][0-9]|2[0-3]):[0-5][0-9]';
final RegExp _reHm = RegExp('^$_hmPattern\$');

/// 正規化済みの HH:mm 形式を返す。許容する入力例:
/// - 730, 07:30, 7:3, 7, 7.5, 7,5
/// - 全角のコロン/ピリオド/ダッシュを含む表記
String? normalizeFlexibleHm(String raw) {
  var value = raw.trim();
  if (value.isEmpty) {
    return null;
  }
  value = value
      .replaceAll('：', ':')
      .replaceAll('．', '.')
      .replaceAll('，', '.')
      .replaceAll('・', '.');

  if (_reHm.hasMatch(value)) {
    return value;
  }

  if (value.contains(':')) {
    final parts = value.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hours = int.tryParse(parts[0]);
    if (hours == null || hours < 0 || hours > 29) {
      return null;
    }
    var minutePart = parts[1];
    if (minutePart.isEmpty) {
      minutePart = '00';
    }
    if (minutePart.length == 1) {
      minutePart = minutePart.padLeft(2, '0');
    }
    if (minutePart.length > 2) {
      return null;
    }
    final minutes = int.tryParse(minutePart);
    if (minutes == null || minutes < 0 || minutes > 59) {
      return null;
    }
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  if (RegExp(r'^\d+(?:[.,]\d+)?$').hasMatch(value)) {
    final hoursDouble = double.tryParse(value.replaceAll(',', '.'));
    if (hoursDouble == null || hoursDouble < 0) {
      return null;
    }
    final totalMinutes = (hoursDouble * 60).round();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 29) {
      return null;
    }
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) {
    return null;
  }
  if (digits.length <= 2) {
    final hours = int.parse(digits);
    if (hours > 29) {
      return null;
    }
    return '${hours.toString().padLeft(2, '0')}:00';
  }
  final hours = int.parse(digits.substring(0, digits.length - 2));
  final minutes = int.parse(digits.substring(digits.length - 2));
  if (hours > 29 || minutes > 59) {
    return null;
  }
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}

String? normalizeFlexibleHmRange(String raw) {
  var value = raw.trim();
  if (value.isEmpty) {
    return null;
  }
  value = value
      .replaceAll('〜', '-')
      .replaceAll('～', '-')
      .replaceAll('ー', '-')
      .replaceAll('―', '-')
      .replaceAll('−', '-');
  final parts =
      value.split('-').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  if (parts.length != 2) {
    return null;
  }
  final start = normalizeFlexibleHm(parts[0]);
  final end = normalizeFlexibleHm(parts[1]);
  if (start == null || end == null) {
    return null;
  }
  return '$start-$end';
}

DateTime parseHm(String value) {
  final normalized = normalizeFlexibleHm(value);
  if (normalized == null) {
    throw FormatException('HH:mm 形式ではありません', value);
  }
  return DateFormat('HH:mm').parse(normalized);
}

bool isValidHm(String value) => normalizeFlexibleHm(value) != null;

class NormalizedSleepInputs {
  const NormalizedSleepInputs({
    required this.total,
    required this.sleep,
    required this.core,
    required this.goal,
  });

  final String total;
  final String sleep;
  final String core;
  final String goal;
}

NormalizedSleepInputs? normalizeSleepEntryInputs({
  required String total,
  required String sleep,
  required String core,
  required String goal,
}) {
  final normalizedTotal = normalizeFlexibleHm(total);
  final normalizedSleep = normalizeFlexibleHmRange(sleep);
  final normalizedCore = normalizeFlexibleHm(core);
  final normalizedGoal = normalizeFlexibleHm(goal);
  if (normalizedTotal == null ||
      normalizedSleep == null ||
      normalizedCore == null ||
      normalizedGoal == null) {
    return null;
  }
  return NormalizedSleepInputs(
    total: normalizedTotal,
    sleep: normalizedSleep,
    core: normalizedCore,
    goal: normalizedGoal,
  );
}

Duration? hmToDuration(String value) {
  final normalized = normalizeFlexibleHm(value);
  if (normalized == null) {
    return null;
  }
  final dt = DateFormat('HH:mm').parse(normalized);
  return Duration(hours: dt.hour, minutes: dt.minute);
}
