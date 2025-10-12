import 'package:flutter/material.dart';
import 'package:sleep_tracker/widgets/text_form_fields/labeled_time_form_field.dart';

/// 睡眠時間(合計)のウィジェット
class TotalSleepFormTextField extends StatelessWidget {
  const TotalSleepFormTextField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return LabeledTimeFormField(
      controller: controller,
      label: '睡眠時間(合計)',
      icon: Icons.timelapse,
      kind: TimeFieldKind.hm,
      onChanged: onChanged,
      helperText: '例: 07:30',
    );
  }
}
