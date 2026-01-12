import 'package:flutter/material.dart';
import 'package:sleep_tracker/utils/time_utils.dart';

enum TimeFieldKind { hm, hmRange }

class LabeledTimeFormField extends StatelessWidget {
  const LabeledTimeFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.kind = TimeFieldKind.hm,
    this.onChanged,
    this.helperText,
    this.hintText,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TimeFieldKind kind;
  final void Function(String)? onChanged;
  final String? helperText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final formatHint = kind == TimeFieldKind.hm ? 'hh:mm' : 'hh:mm-hh:mm';
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(icon),
        hintText: hintText ?? formatHint,
        helperText: helperText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '入力してください。';
        }
        final normalized = kind == TimeFieldKind.hm
            ? normalizeFlexibleHm(value)
            : normalizeFlexibleHmRange(value);
        if (normalized == null) {
          return '正しい時間形式($formatHint)で入力してください。';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
