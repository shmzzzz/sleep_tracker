import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/widgets/appbar_component_widget.dart';
import 'package:sleep_tracker/widgets/sleep_entry_date_picker_tile.dart';
import 'package:sleep_tracker/widgets/sleep_entry_form_layout.dart';
import 'package:sleep_tracker/widgets/sleep_entry_preview_card.dart';
import 'package:sleep_tracker/widgets/text_form_fields/core_sleep_form_text_field.dart';
import 'package:sleep_tracker/widgets/text_form_fields/goal_sleep_form_text_field.dart';
import 'package:sleep_tracker/widgets/text_form_fields/sleep_hours_form_text_field.dart';
import 'package:sleep_tracker/widgets/text_form_fields/total_sleep_form_text_field.dart';
import 'package:sleep_tracker/services/sleep_repository.dart';
import 'package:sleep_tracker/utils/context_extensions.dart';
import 'package:sleep_tracker/utils/time_utils.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';
import 'package:intl/intl.dart';

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
        final normalized = normalizeSleepEntryInputs(
          total: totalController.text,
          sleep: sleepController.text,
          core: coreController.text,
          goal: goalController.text,
        );
        if (normalized == null) {
          throw const FormatException('入力値を正規化できません。');
        }

        totalController.text = normalized.total;
        sleepController.text = normalized.sleep;
        coreController.text = normalized.core;
        goalController.text = normalized.goal;

        final achieved = isAchievedByHm(normalized.total, normalized.goal);
        const repo = SleepRepository();
        await repo.update(userUid, widget.entry.id, {
          'total': normalized.total,
          'sleep': normalized.sleep,
          'core': normalized.core,
          'goal': normalized.goal,
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

  String _buildCreatedAtLabel() {
    final createdLabel = DateFormat('yyyy年M月d日(E)', 'ja_JP')
        .format(selectedDate);
    return '記録日時: $createdLabel';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponentWidget(
        title: '睡眠データを編集',
      ),
      body: SafeArea(
        child: SleepEntryFormLayout(
          formKey: _formKey,
          title: '睡眠データを編集',
          description: '記録内容を更新すると統計情報とグラフにも即時反映されます。',
          previewCard: _buildPreviewCard(),
          datePickerTile: SleepEntryDatePickerTile(
            selectedDate: selectedDate,
            onTap: _pickDate,
            leadingIcon: Icons.calendar_month,
          ),
          fields: [
            TotalSleepFormTextField(
              controller: totalController,
            ),
            SleepHoursFormTextField(
              controller: sleepController,
            ),
            CoreSleepFormTextField(
              controller: coreController,
            ),
            GoalSleepFormTextField(
              controller: goalController,
            ),
          ],
          primaryAction: FilledButton.icon(
            onPressed: _submitData,
            icon: const Icon(Icons.save_alt_rounded),
            label: const Text('更新する'),
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              padding: UiConstants.sleepFormPrimaryButtonPadding,
            ),
          ),
          secondaryAction: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('戻る'),
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: UiConstants.sleepFormSecondaryButtonPadding,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return AnimatedBuilder(
      animation: Listenable.merge([totalController, goalController]),
      builder: (context, _) {
        return SleepEntryPreviewCard(
          total: totalController.text,
          goal: goalController.text,
          achievedIcon: Icons.flag_rounded,
          unachievedIcon: Icons.alarm_rounded,
          achievedColor: Theme.of(context).colorScheme.primary,
          unachievedColor: Theme.of(context).colorScheme.tertiary,
          emptyStateText: '目標との差分を確認してから更新しましょう。',
          achievedText: '目標を達成しています。継続を応援します！',
          unachievedText: '目標未達です。睡眠リズムを見直してみましょう。',
          createdAtLabel: _buildCreatedAtLabel(),
        );
      },
    );
  }
}
