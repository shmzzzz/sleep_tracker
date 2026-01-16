import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        final normalized = normalizeSleepEntryInputs(
          total: _totalSleepHourController.text,
          sleep: _sleepHourController.text,
          core: _coreSleepHourController.text,
          goal: _goalSleepHourController.text,
        );
        if (normalized == null) {
          throw const FormatException('入力値を正規化できません。');
        }

        _totalSleepHourController.text = normalized.total;
        _sleepHourController.text = normalized.sleep;
        _coreSleepHourController.text = normalized.core;
        _goalSleepHourController.text = normalized.goal;
        // 目標との比較
        isAchieved = isAchievedByHm(normalized.total, normalized.goal);
        // FireStoreにデータを保存する
        const repo = SleepRepository();
        await repo.add(userUid, {
          'total': normalized.total,
          'sleep': normalized.sleep,
          'core': normalized.core,
          'goal': normalized.goal,
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
        child: SleepEntryFormLayout(
          formKey: _formKey,
          title: '新しい睡眠データを記録',
          description: '目標睡眠時間との差を確認しながら、合計/睡眠/コア時間を入力しましょう。',
          previewCard: _buildPreviewCard(),
          datePickerTile: SleepEntryDatePickerTile(
            selectedDate: selectedDate,
            onTap: _pickDate,
            leadingIcon: Icons.calendar_today,
          ),
          fields: [
            TotalSleepFormTextField(
              controller: _totalSleepHourController,
            ),
            SleepHoursFormTextField(
              controller: _sleepHourController,
            ),
            CoreSleepFormTextField(
              controller: _coreSleepHourController,
            ),
            GoalSleepFormTextField(
              controller: _goalSleepHourController,
            ),
          ],
          primaryAction: FilledButton.icon(
            onPressed: _submitData,
            icon: const Icon(Icons.cloud_upload_rounded),
            label: const Text('保存する'),
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              padding: UiConstants.sleepFormPrimaryButtonPadding,
            ),
          ),
          secondaryAction: OutlinedButton.icon(
            onPressed: _clearText,
            icon: const Icon(Icons.clear_all),
            label: const Text('リセット'),
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
      animation: Listenable.merge([
        _totalSleepHourController,
        _goalSleepHourController,
      ]),
      builder: (context, _) {
        return SleepEntryPreviewCard(
          total: _totalSleepHourController.text,
          goal: _goalSleepHourController.text,
          achievedIcon: Icons.emoji_events,
          unachievedIcon: Icons.self_improvement,
          achievedColor: Theme.of(context).colorScheme.primary,
          unachievedColor: Theme.of(context).colorScheme.secondary,
          emptyStateText: '目標時間を入力すると達成状況が確認できます。',
          achievedText: '目標達成おめでとうございます！',
          unachievedText: '目標まであと少し、次回も頑張りましょう。',
        );
      },
    );
  }
}
