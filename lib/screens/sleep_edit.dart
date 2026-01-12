import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/widgets/appbar_component_widget.dart';
import 'package:sleep_tracker/widgets/text_form_fields/core_sleep_form_text_field.dart';
import 'package:sleep_tracker/widgets/text_form_fields/goal_sleep_form_text_field.dart';
import 'package:sleep_tracker/widgets/text_form_fields/sleep_hours_form_text_field.dart';
import 'package:sleep_tracker/widgets/text_form_fields/total_sleep_form_text_field.dart';
import 'package:sleep_tracker/services/sleep_repository.dart';
import 'package:sleep_tracker/utils/context_extensions.dart';
import 'package:sleep_tracker/utils/time_utils.dart';

const _dateRangeYears = 5;
const _pagePadding = EdgeInsets.symmetric(horizontal: 20, vertical: 24);
const _headerSpacing = 8.0;
const _sectionSpacing = 20.0;
const _sectionSpacingLarge = 24.0;
const _cardSpacing = 18.0;
const _fieldSpacing = 18.0;
const _buttonTopSpacing = 28.0;
const _buttonSpacing = 12.0;
const _primaryButtonPadding =
    EdgeInsets.symmetric(horizontal: 26, vertical: 14);
const _secondaryButtonPadding =
    EdgeInsets.symmetric(horizontal: 24, vertical: 12);
const _previewPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 18);
const _previewCornerRadius = 20.0;
const _previewShadowOpacity = 0.06;
const _previewShadowBlur = 14.0;
const _previewShadowOffset = Offset(0, 8);
const _previewStatusIconSize = 28.0;
const _previewStatusSpacing = 12.0;
const _previewMetricsSpacing = 18.0;
const _metricSpacing = 6.0;
const _metricLabelOpacity = 0.75;
const _dateTileCornerRadius = 18.0;
const _dateTilePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);

class SleepEditScreen extends StatefulWidget {
  const SleepEditScreen({
    super.key,
    required this.entry,
  });

  final SleepEntry entry;

  @override
  State<SleepEditScreen> createState() => _SleepEditScreenState();
}

class _SleepEditScreenState extends State<SleepEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController totalController;
  late TextEditingController sleepController;
  late TextEditingController coreController;
  late TextEditingController goalController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    // initialDataが外側から受け取った変数なので、widgetを経由して取得する
    totalController = TextEditingController(text: widget.entry.total);
    sleepController = TextEditingController(text: widget.entry.sleep);
    coreController = TextEditingController(text: widget.entry.core);
    goalController = TextEditingController(text: widget.entry.goal);
    final created = widget.entry.createdAt;
    selectedDate = DateTime(created.year, created.month, created.day);
  }

  @override
  void dispose() {
    totalController.dispose();
    sleepController.dispose();
    coreController.dispose();
    goalController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userUid = FirebaseAuth.instance.currentUser!.uid;
        final normalizedTotal = normalizeFlexibleHm(totalController.text)!;
        final normalizedSleep = normalizeFlexibleHmRange(sleepController.text)!;
        final normalizedCore = normalizeFlexibleHm(coreController.text)!;
        final normalizedGoal = normalizeFlexibleHm(goalController.text)!;

        totalController.text = normalizedTotal;
        sleepController.text = normalizedSleep;
        coreController.text = normalizedCore;
        goalController.text = normalizedGoal;

        final achieved = isAchievedByHm(normalizedTotal, normalizedGoal);
        const repo = SleepRepository();
        await repo.update(userUid, widget.entry.id, {
          'total': normalizedTotal,
          'sleep': normalizedSleep,
          'core': normalizedCore,
          'goal': normalizedGoal,
          'isAchieved': achieved,
          'createdAt': Timestamp.fromDate(selectedDate),
        });
        // 一覧画面への遷移（新しい達成状態を返す）
        if (!mounted) {
          return;
        }
        Navigator.of(context).pop(achieved);
      } catch (error) {
        if (!mounted) {
          return;
        }
        context.showSnackBar(error.toString());
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - _dateRangeYears),
      lastDate: now,
      locale: const Locale('ja'),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponentWidget(
        title: '睡眠データを編集',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: _pagePadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '睡眠データを編集',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: _headerSpacing),
                Text(
                  '記録内容を更新すると統計情報とグラフにも即時反映されます。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: _sectionSpacing),
                _EditPreviewCard(
                  total: totalController.text,
                  goal: goalController.text,
                  createdAt: selectedDate,
                ),
                const SizedBox(height: _cardSpacing),
                _EditDatePickerTile(
                  selectedDate: selectedDate,
                  onTap: _pickDate,
                ),
                const SizedBox(height: _sectionSpacingLarge),
                TotalSleepFormTextField(
                  controller: totalController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: _fieldSpacing),
                SleepHoursFormTextField(
                  controller: sleepController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: _fieldSpacing),
                CoreSleepFormTextField(
                  controller: coreController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: _fieldSpacing),
                GoalSleepFormTextField(
                  controller: goalController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: _buttonTopSpacing),
                FilledButton.icon(
                  onPressed: _submitData,
                  icon: const Icon(Icons.save_alt_rounded),
                  label: const Text('更新する'),
                  style: FilledButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: _primaryButtonPadding,
                  ),
                ),
                const SizedBox(height: _buttonSpacing),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('戻る'),
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: _secondaryButtonPadding,
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

class _EditPreviewCard extends StatelessWidget {
  const _EditPreviewCard({
    required this.total,
    required this.goal,
    required this.createdAt,
  });

  final String total;
  final String goal;
  final DateTime createdAt;

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
    final statusColor = achieved ? colorScheme.primary : colorScheme.tertiary;
    final statusText = !hasEnoughData
        ? '目標との差分を確認してから更新しましょう。'
        : achieved
            ? '目標を達成しています。継続を応援します！'
            : '目標未達です。睡眠リズムを見直してみましょう。';

    final createdLabel = DateFormat('yyyy年M月d日(E)', 'ja_JP').format(createdAt);

    return Container(
      padding: _previewPadding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(_previewCornerRadius),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(_previewShadowOpacity),
            blurRadius: _previewShadowBlur,
            offset: _previewShadowOffset,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                achieved ? Icons.flag_rounded : Icons.alarm_rounded,
                color: statusColor,
                size: _previewStatusIconSize,
              ),
              const SizedBox(width: _previewStatusSpacing),
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
          const SizedBox(height: _previewMetricsSpacing),
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
          const SizedBox(height: _previewMetricsSpacing),
          Text(
            '記録日時: $createdLabel',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _EditDatePickerTile extends StatelessWidget {
  const _EditDatePickerTile({
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
        borderRadius: BorderRadius.circular(_dateTileCornerRadius),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: _dateTilePadding,
        leading: Icon(Icons.calendar_month, color: colorScheme.primary),
        title: const Text('記録日'),
        subtitle: Text(formatted),
        trailing: const Icon(Icons.edit_calendar_outlined),
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
                color: color.withOpacity(_metricLabelOpacity),
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: _metricSpacing),
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
