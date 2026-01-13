import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleep_tracker/widgets/appbar_component_widget.dart';
import 'package:sleep_tracker/widgets/text_form_fields/core_sleep_form_text_field.dart';
import 'package:sleep_tracker/widgets/text_form_fields/goal_sleep_form_text_field.dart';
import 'package:sleep_tracker/widgets/text_form_fields/sleep_hours_form_text_field.dart';
import 'package:sleep_tracker/widgets/text_form_fields/total_sleep_form_text_field.dart';
import 'package:sleep_tracker/services/sleep_repository.dart';
import 'package:sleep_tracker/utils/context_extensions.dart';
import 'package:sleep_tracker/utils/time_utils.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

class SleepAddScreen extends StatefulWidget {
  const SleepAddScreen({super.key});

  @override
  State<SleepAddScreen> createState() => _SleepAddScreenState();
}

class _SleepAddScreenState extends State<SleepAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _totalSleepHourController = TextEditingController();
  final _sleepHourController = TextEditingController();
  final _coreSleepHourController = TextEditingController();
  final _goalSleepHourController = TextEditingController();

  String inputTotal = '';
  String inputSleep = '';
  String inputCore = '';
  String inputGoal = '';
  DateTime selectedDate = DateTime.now();
  late bool isAchieved;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - UiConstants.sleepFormDateRangeYears),
      lastDate: now,
      locale: const Locale('ja'),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userUid = FirebaseAuth.instance.currentUser!.uid;
        final normalizedTotal =
            normalizeFlexibleHm(_totalSleepHourController.text)!;
        final normalizedSleep =
            normalizeFlexibleHmRange(_sleepHourController.text)!;
        final normalizedCore =
            normalizeFlexibleHm(_coreSleepHourController.text)!;
        final normalizedGoal =
            normalizeFlexibleHm(_goalSleepHourController.text)!;

        _totalSleepHourController.text = normalizedTotal;
        _sleepHourController.text = normalizedSleep;
        _coreSleepHourController.text = normalizedCore;
        _goalSleepHourController.text = normalizedGoal;
        inputTotal = normalizedTotal;
        inputSleep = normalizedSleep;
        inputCore = normalizedCore;
        inputGoal = normalizedGoal;

        // 目標との比較
        isAchieved = isAchievedByHm(normalizedTotal, normalizedGoal);
        // FireStoreにデータを保存する
        const repo = SleepRepository();
        await repo.add(userUid, {
          'total': normalizedTotal,
          'sleep': normalizedSleep,
          'core': normalizedCore,
          'goal': normalizedGoal,
          'isAchieved': isAchieved,
          'createdAt': Timestamp.fromDate(selectedDate),
        });
        // 一覧画面への遷移
        if (!mounted) {
          return;
        }
        Navigator.of(context).pop();
      } catch (error) {
        if (!mounted) {
          return;
        }
        context.showSnackBar(error.toString());
      }
    }
  }

  void _clearText() {
    setState(() {
      _totalSleepHourController.text = '';
      _sleepHourController.text = '';
      _coreSleepHourController.text = '';
      _goalSleepHourController.text = '';
      inputTotal = '';
      inputSleep = '';
      inputCore = '';
      inputGoal = '';
    });
  }

  @override
  void dispose() {
    _totalSleepHourController.dispose();
    _sleepHourController.dispose();
    _coreSleepHourController.dispose();
    _goalSleepHourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponentWidget(
        title: '睡眠データを追加',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: UiConstants.sleepFormPagePadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '新しい睡眠データを記録',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: UiConstants.sleepFormHeaderSpacing),
                Text(
                  '目標睡眠時間との差を確認しながら、合計/睡眠/コア時間を入力しましょう。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: UiConstants.sleepFormSectionSpacing),
                _PreviewCard(
                  total: inputTotal,
                  goal: inputGoal,
                ),
                const SizedBox(height: UiConstants.sleepFormCardSpacing),
                _DatePickerTile(
                  selectedDate: selectedDate,
                  onTap: _pickDate,
                ),
                const SizedBox(
                    height: UiConstants.sleepFormSectionSpacingLarge),
                TotalSleepFormTextField(
                  controller: _totalSleepHourController,
                  onChanged: (value) {
                    setState(() {
                      inputTotal = value;
                    });
                  },
                ),
                const SizedBox(height: UiConstants.sleepFormFieldSpacing),
                SleepHoursFormTextField(
                  controller: _sleepHourController,
                  onChanged: (value) {
                    setState(() {
                      inputSleep = value;
                    });
                  },
                ),
                const SizedBox(height: UiConstants.sleepFormFieldSpacing),
                CoreSleepFormTextField(
                  controller: _coreSleepHourController,
                  onChanged: (value) {
                    setState(() {
                      inputCore = value;
                    });
                  },
                ),
                const SizedBox(height: UiConstants.sleepFormFieldSpacing),
                GoalSleepFormTextField(
                  controller: _goalSleepHourController,
                  onChanged: (value) {
                    setState(() {
                      inputGoal = value;
                    });
                  },
                ),
                const SizedBox(height: UiConstants.sleepFormButtonTopSpacing),
                FilledButton.icon(
                  onPressed: _submitData,
                  icon: const Icon(Icons.cloud_upload_rounded),
                  label: const Text('保存する'),
                  style: FilledButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: UiConstants.sleepFormPrimaryButtonPadding,
                  ),
                ),
                const SizedBox(height: UiConstants.sleepFormButtonSpacing),
                OutlinedButton.icon(
                  onPressed: _clearText,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('リセット'),
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: UiConstants.sleepFormSecondaryButtonPadding,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.total,
    required this.goal,
  });

  final String total;
  final String goal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalDuration = hmToDuration(total);
    final goalDuration = hmToDuration(goal);

    final bool hasEnoughData = totalDuration != null && goalDuration != null;
    final difference = hasEnoughData
        ? formatDurationDifference(totalDuration - goalDuration)
        : '--';
    final achieved = hasEnoughData && totalDuration >= goalDuration;

    final statusText = !hasEnoughData
        ? '目標時間を入力すると達成状況が確認できます。'
        : achieved
            ? '目標達成おめでとうございます！'
            : '目標まであと少し、次回も頑張りましょう。';

    final statusColor = achieved ? colorScheme.primary : colorScheme.secondary;

    return Container(
      padding: UiConstants.sleepFormPreviewPadding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
            BorderRadius.circular(UiConstants.sleepFormPreviewCornerRadius),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(
                UiConstants.sleepFormPreviewShadowOpacity),
            blurRadius: UiConstants.sleepFormPreviewShadowBlur,
            offset: UiConstants.sleepFormPreviewShadowOffset,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                achieved ? Icons.emoji_events : Icons.self_improvement,
                color: statusColor,
                size: UiConstants.sleepFormPreviewStatusIconSize,
              ),
              const SizedBox(width: UiConstants.sleepFormPreviewStatusSpacing),
              Expanded(
                child: Text(
                  statusText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: UiConstants.sleepFormPreviewMetricsSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PreviewMetric(
                label: '合計睡眠',
                value: total.isEmpty ? '--:--' : total,
                color: colorScheme.primary,
              ),
              _PreviewMetric(
                label: '目標',
                value: goal.isEmpty ? '--:--' : goal,
                color: colorScheme.secondary,
              ),
              _PreviewMetric(
                label: '差分',
                value: difference,
                color: statusColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withOpacity(UiConstants.sleepFormMetricLabelOpacity),
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: UiConstants.sleepFormMetricSpacing),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({
    required this.selectedDate,
    required this.onTap,
  });

  final DateTime selectedDate;
  final VoidCallback onTap;

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
        leading: Icon(Icons.calendar_today, color: colorScheme.primary),
        title: const Text('記録日'),
        subtitle: Text(formatted),
        trailing: const Icon(Icons.edit_calendar_outlined),
      ),
    );
  }
}
