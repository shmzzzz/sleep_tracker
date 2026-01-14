import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

class SleepEntryDatePickerTile extends StatelessWidget {
  const SleepEntryDatePickerTile({
    super.key,
    required this.selectedDate,
    required this.onTap,
    required this.leadingIcon,
  });

  final DateTime selectedDate;
  final VoidCallback onTap;
  final IconData leadingIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatted = DateFormat('yyyy年M月d日(E)', 'ja_JP').format(selectedDate);
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
            BorderRadius.circular(UiConstants.sleepFormDateTileCornerRadius),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: UiConstants.sleepFormDateTilePadding,
        leading: Icon(leadingIcon, color: colorScheme.primary),
        title: const Text('記録日'),
        subtitle: Text(formatted),
        trailing: const Icon(Icons.edit_calendar_outlined),
      ),
    );
  }
}
