import 'package:intl/intl.dart';
import 'package:sleep_tracker/utils/time_parsing_utils.dart';

String formatHm(Duration duration) {
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  return '$hours:$minutes';
}

String formatDurationInJapanese(Duration? duration) {
  if (duration == null) {
    return '--';
  }
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final buffer = StringBuffer();
  if (hours > 0) {
    buffer.write('$hours時間');
  }
  if (minutes > 0 || hours == 0) {
    buffer.write('$minutes分');
  }
  return buffer.toString();
}

String formatDurationDifference(Duration difference) {
  if (difference.inMinutes == 0) {
    return '±0分';
  }
  final prefix = difference.isNegative ? '-' : '+';
  final positive = difference.abs();
  final hours = positive.inHours;
  final minutes = positive.inMinutes % 60;
  final parts = <String>[];
  if (hours > 0) {
    parts.add('$hours時間');
  }
  if (minutes > 0 || hours == 0) {
    parts.add('$minutes分');
  }
  return '$prefix${parts.join()}';
}

String formatDayLabel(DateTime dateTime) {
  return DateFormat('M/d', 'ja_JP').format(dateTime);
}

bool isAchievedByHm(String total, String goal) {
  final totalDuration = hmToDuration(total);
  final goalDuration = hmToDuration(goal);
  if (totalDuration == null || goalDuration == null) {
    return false;
  }
  return totalDuration >= goalDuration;
}
