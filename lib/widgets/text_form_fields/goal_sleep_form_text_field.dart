import 'package:flutter/material.dart';
import 'package:sleep_tracker/widgets/text_form_fields/labeled_time_form_field.dart';

/// 目標睡眠時間のウィジェット
class GoalSleepFormTextField extends StatelessWidget {
  const GoalSleepFormTextField({
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
      label: '目標睡眠時間',
      icon: Icons.checklist_outlined,
      kind: TimeFieldKind.hm,
      onChanged: onChanged,
      helperText: '例: 07:30',
    );
  }
}
