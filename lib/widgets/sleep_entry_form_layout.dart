import 'package:flutter/material.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

class SleepEntryFormLayout extends StatelessWidget {
  const SleepEntryFormLayout({
    super.key,
    required this.formKey,
    required this.title,
    required this.description,
    required this.previewCard,
    required this.datePickerTile,
    required this.fields,
    required this.primaryAction,
    required this.secondaryAction,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final String description;
  final Widget previewCard;
  final Widget datePickerTile;
  final List<Widget> fields;
  final Widget primaryAction;
  final Widget secondaryAction;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: UiConstants.sleepFormPagePadding,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: UiConstants.sleepFormHeaderSpacing),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: UiConstants.sleepFormSectionSpacing),
            previewCard,
            const SizedBox(height: UiConstants.sleepFormCardSpacing),
            datePickerTile,
            const SizedBox(height: UiConstants.sleepFormSectionSpacingLarge),
            ..._buildFieldWidgets(),
            const SizedBox(height: UiConstants.sleepFormButtonTopSpacing),
            primaryAction,
            const SizedBox(height: UiConstants.sleepFormButtonSpacing),
            secondaryAction,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFieldWidgets() {
    if (fields.isEmpty) {
      return const [];
    }
    return [
      for (var index = 0; index < fields.length; index++) ...[
        fields[index],
        if (index != fields.length - 1)
          const SizedBox(height: UiConstants.sleepFormFieldSpacing),
      ],
    ];
  }
}
