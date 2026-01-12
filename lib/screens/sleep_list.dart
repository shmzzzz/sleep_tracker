import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/models/sleep_entry.dart';
import 'package:sleep_tracker/screens/sleep_add.dart';
import 'package:sleep_tracker/widgets/appbar_component_widget.dart';
import 'package:sleep_tracker/widgets/drawer_list.dart';
import 'package:sleep_tracker/widgets/sleep_list_item.dart';
import 'package:sleep_tracker/services/sleep_repository.dart';
import 'package:sleep_tracker/utils/sleep_statistics.dart';
import 'package:sleep_tracker/widgets/statistics/sleep_statistics_overview.dart';

const _listBottomPadding = EdgeInsets.only(bottom: 96);
const _fabPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 14);
const _emptyStatePadding = EdgeInsets.symmetric(horizontal: 32, vertical: 40);
const _emptyStateIconSize = 64.0;
const _emptyStateTitleSpacing = 16.0;
const _emptyStateBodySpacing = 8.0;
const _emptyStateButtonSpacing = 24.0;
const _errorIconSize = 48.0;
const _errorTitleSpacing = 12.0;
const _errorBodySpacing = 8.0;

class SleepListScreen extends StatefulWidget {
  const SleepListScreen({super.key});

  @override
  State<SleepListScreen> createState() => _SleepListScreenState();
}

class _SleepListScreenState extends State<SleepListScreen> {
  static const SleepRepository _repository = SleepRepository();

  void _goToAdd() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const SleepAddScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userUid = FirebaseAuth.instance.currentUser!.uid;
    const String appBarTitle = '睡眠データ一覧';

    return StreamBuilder<List<SleepEntry>>(
      stream: _repository.streamEntries(userUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildScaffold(
            title: appBarTitle,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return _buildScaffold(
            title: appBarTitle,
            body: const _ErrorState(),
          );
        }

        final entries = snapshot.data ?? <SleepEntry>[];
        if (entries.isEmpty) {
          return _buildScaffold(
            title: appBarTitle,
            body: _EmptyState(onAdd: _goToAdd),
          );
        }

        final statistics = SleepStatistics.fromEntries(entries);

        return _buildScaffold(
          title: appBarTitle,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SleepStatisticsOverview(
                  statistics: statistics,
                  entries: entries,
                ),
              ),
              SliverPadding(
                padding: _listBottomPadding,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = entries[index];
                      return SleepListItem(
                        key: ValueKey(entry.id),
                        entry: entry,
                      );
                    },
                    childCount: entries.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Scaffold _buildScaffold({
    required String title,
    required Widget body,
  }) {
    return Scaffold(
      appBar: AppBarComponentWidget(title: title),
      drawer: const DrawerList(),
      body: SafeArea(child: body),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton.icon(
        onPressed: _goToAdd,
        icon: const Icon(Icons.add),
        label: const Text('記録する'),
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          padding: _fabPadding,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: _emptyStatePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.nightlight_round,
              size: _emptyStateIconSize,
              color: colorScheme.primary,
            ),
            const SizedBox(height: _emptyStateTitleSpacing),
            Text(
              '最初の睡眠記録を追加しましょう',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: _emptyStateBodySpacing),
            Text(
              '目標に対する達成状況や睡眠トレンドを記録していくと、生活リズムの改善に役立ちます。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: _emptyStateButtonSpacing),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('睡眠データを追加'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: _errorIconSize),
          const SizedBox(height: _errorTitleSpacing),
          Text(
            'データの読み込みに失敗しました。',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: _errorBodySpacing),
          Text(
            '通信環境を確認してからもう一度お試しください。',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
