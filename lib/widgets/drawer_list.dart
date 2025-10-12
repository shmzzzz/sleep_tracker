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
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.onPrimary.withOpacity(0.2),
                  child: Icon(
                    Icons.nightlight_round,
                    size: 32,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Sleep Tracker',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: ListTile(
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
              trailing: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: ListTile(
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
              trailing: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('ログアウト'),
              trailing: LogoutButton(),
            ),
          ),
        ],
      ),
    );
  }
}
