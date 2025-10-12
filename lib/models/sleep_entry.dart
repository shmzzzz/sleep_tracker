import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sleep_tracker/utils/time_utils.dart';

class SleepEntry {
  SleepEntry({
    required this.id,
    required this.total,
    required this.sleep,
    required this.core,
    required this.goal,
    required this.isAchieved,
    required this.createdAt,
  });

  final String id;
  final String total;
  final String sleep;
  final String core;
  final String goal;
  final bool isAchieved;
  final DateTime createdAt;

  Duration? get totalDuration => hmToDuration(total);
  Duration? get sleepDuration => hmToDuration(sleep);
  Duration? get coreDuration => hmToDuration(core);
  Duration? get goalDuration => hmToDuration(goal);

  SleepEntry copyWith({
    String? total,
    String? sleep,
    String? core,
    String? goal,
    bool? isAchieved,
    DateTime? createdAt,
  }) {
    return SleepEntry(
      id: id,
      total: total ?? this.total,
      sleep: sleep ?? this.sleep,
      core: core ?? this.core,
      goal: goal ?? this.goal,
      isAchieved: isAchieved ?? this.isAchieved,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'sleep': sleep,
      'core': core,
      'goal': goal,
      'isAchieved': isAchieved,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory SleepEntry.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};
    return SleepEntry(
      id: document.id,
      total: (data['total'] ?? '') as String,
      sleep: (data['sleep'] ?? '') as String,
      core: (data['core'] ?? '') as String,
      goal: (data['goal'] ?? '') as String,
      isAchieved: (data['isAchieved'] ?? false) as bool,
      createdAt: _parseCreatedAt(data['createdAt']),
    );
  }

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }
}
