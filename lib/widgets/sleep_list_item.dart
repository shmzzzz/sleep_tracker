import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/screens/sleep_edit.dart';
import 'package:sleep_tracker/services/sleep_repository.dart';
import 'package:sleep_tracker/utils/context_extensions.dart';
import 'package:sleep_tracker/utils/time_utils.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

class SleepListItem extends StatefulWidget {
  const SleepListItem({
    super.key,
    required this.entry,
  });

  final SleepEntry entry;

  @override
  State<SleepListItem> createState() => _SleepListItemState();
}

class _SleepListItemState extends State<SleepListItem> {
  bool isAchieved = false;

  void updateAchievement(bool updatedAchievement) {
    setState(() {
      isAchieved = updatedAchievement;
    });
  }

  Future<void> deleteData(String documentId) async {
    try {
      final userUid = FirebaseAuth.instance.currentUser!.uid;
      const repo = SleepRepository();
      await repo.delete(userUid, documentId);
      if (!mounted) return;
      context.showSnackBar('睡眠データを削除しました。');
    } catch (error) {
      if (!mounted) return;
      context.showSnackBar(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // 初期表示は保存済みの値に合わせる
    isAchieved = widget.entry.isAchieved;
  }

  @override
  void didUpdateWidget(covariant SleepListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.id != widget.entry.id ||
        oldWidget.entry.isAchieved != widget.entry.isAchieved) {
      isAchieved = widget.entry.isAchieved;
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final createdLabel =
        DateFormat('M月d日 (E)', 'ja_JP').format(entry.createdAt);
    final goalDifferenceText = _goalDifferenceText();
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: UiConstants.sleepListItemPadding,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(UiConstants.sleepListItemCornerRadius),
          onTap: () async {
            final result = await Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) {
                  return SleepEditScreen(entry: entry);
                },
              ),
            );
            if (result is bool) updateAchievement(result);
          },
          child: Ink(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  BorderRadius.circular(UiConstants.sleepListItemCornerRadius),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(
                      UiConstants.sleepListItemShadowOpacity),
                  blurRadius: UiConstants.sleepListItemShadowBlur,
                  offset: UiConstants.sleepListItemShadowOffset,
                ),
              ],
            ),
            child: Padding(
              padding: UiConstants.sleepListItemInnerPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: UiConstants.sleepListItemAvatarRadius,
                        backgroundColor: isAchieved
                            ? colorScheme.primaryContainer
                            : colorScheme.secondaryContainer,
                        child: Icon(
                          isAchieved ? Icons.check_rounded : Icons.bed_rounded,
                          color: isAchieved
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(
                          width: UiConstants.sleepListItemAvatarSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.total,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(
                                height: UiConstants.sleepListItemTitleSpacing),
                            Row(
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  size: UiConstants.sleepListItemGoalIconSize,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(
                                    width: UiConstants.sleepListItemGoalSpacing),
                                Text(
                                  '目標差: $goalDifferenceText',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(context),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: UiConstants.sleepListItemSectionSpacing),
                  Wrap(
                    spacing: UiConstants.sleepListItemChipSpacing,
                    runSpacing: UiConstants.sleepListItemChipSpacing,
                    children: [
                      _InfoChip(
                        icon: Icons.single_bed_rounded,
                        label: '睡眠',
                        value: entry.sleep,
                        color: colorScheme.secondary,
                        textColor: colorScheme.onSurface,
                      ),
                      _InfoChip(
                        icon: Icons.bedtime,
                        label: 'コア',
                        value: entry.core,
                        color: colorScheme.tertiary,
                        textColor: colorScheme.onSurface,
                      ),
                      _InfoChip(
                        icon: Icons.flag_circle,
                        label: '目標',
                        value: entry.goal,
                        color: colorScheme.primary,
                        textColor: colorScheme.onSurface,
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: UiConstants.sleepListItemSectionSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        createdLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) =>
                                  SleepEditScreen(entry: entry),
                            ),
                          );
                          if (result is bool) updateAchievement(result);
                        },
                        child: const Text('編集'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _goalDifferenceText() {
    final total = widget.entry.totalDuration;
    final goal = widget.entry.goalDuration;
    if (total == null || goal == null) {
      return '--';
    }
    return formatDurationDifference(total - goal);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('削除しますか？'),
          content: const Text('この睡眠記録を削除すると元に戻せません。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('削除する'),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true) return;
    await deleteData(widget.entry.id);
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: UiConstants.sleepListItemChipPadding,
      decoration: BoxDecoration(
        color: color.withOpacity(UiConstants.sleepListItemChipBackgroundOpacity),
        borderRadius:
            BorderRadius.circular(UiConstants.sleepListItemChipCornerRadius),
        border: Border.all(
            color: color.withOpacity(UiConstants.sleepListItemChipBorderOpacity)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: UiConstants.sleepListItemChipIconSize, color: color),
          const SizedBox(width: UiConstants.sleepListItemChipIconSpacing),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor
                          .withOpacity(UiConstants.sleepListItemChipLabelOpacity),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
