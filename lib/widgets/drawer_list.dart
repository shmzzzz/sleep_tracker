import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/screens/sleep_add.dart';
import 'package:sleep_tracker/screens/sleep_list.dart';
import 'package:sleep_tracker/widgets/logout_button.dart';

class DrawerList extends StatelessWidget {
  const DrawerList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.nightlight_round,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Sleep Tracker',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary.withOpacity(0.85),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.analytics_outlined),
                  title: const Text('睡眠データ一覧'),
                  subtitle: const Text('トレンドと達成状況を確認'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                        builder: (context) {
                          return const SleepListScreen();
                        },
                      ),
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ),
                Divider(color: colorScheme.outlineVariant),
                ListTile(
                  leading: const Icon(Icons.add_alarm_outlined),
                  title: const Text('睡眠データ追加'),
                  subtitle: const Text('新しい記録を登録'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) {
                          return const SleepAddScreen();
                        },
                      ),
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: LogoutButton(
                compact: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
