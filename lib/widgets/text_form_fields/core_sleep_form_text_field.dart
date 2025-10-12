import 'package:flutter/material.dart';
import 'package:sleep_tracker/widgets/text_form_fields/labeled_time_form_field.dart';

/// 深い睡眠のウィジェット
class CoreSleepFormTextField extends StatelessWidget {
  const CoreSleepFormTextField({
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
      label: '深い睡眠',
      icon: Icons.bedtime_outlined,
      kind: TimeFieldKind.hm,
      onChanged: onChanged,
      helperText: '例: 02:30',
    );
  }
}
