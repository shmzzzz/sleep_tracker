import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/screens/sleep_add.dart';
import 'package:sleep_tracker/screens/sleep_list.dart';
import 'package:sleep_tracker/widgets/logout_button.dart';

const _drawerPadding = EdgeInsets.fromLTRB(20, 24, 20, 16);
const _profilePadding = EdgeInsets.fromLTRB(18, 18, 18, 16);
const _profileCornerRadius = 20.0;
const _profileIconSize = 44.0;
const _profileIconCornerRadius = 14.0;
const _profileTitleSpacing = 12.0;
const _profileEmailSpacing = 4.0;
const _profileIconOpacity = 0.2;
const _profileEmailOpacity = 0.85;
const _sectionSpacing = 20.0;
const _menuPadding = EdgeInsets.all(6);
const _menuCornerRadius = 18.0;
const _menuChevronSize = 16.0;
const _logoutPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
const _logoutCornerRadius = 18.0;

class DrawerList extends StatelessWidget {
  const DrawerList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: _drawerPadding,
        children: [
          Container(
            padding: _profilePadding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(_profileCornerRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: _profileIconSize,
                  height: _profileIconSize,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withOpacity(_profileIconOpacity),
                    borderRadius: BorderRadius.circular(_profileIconCornerRadius),
                  ),
                  child: Icon(
                    Icons.nightlight_round,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: _profileTitleSpacing),
                Text(
                  'Sleep Tracker',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: _profileEmailSpacing),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            colorScheme.onPrimary.withOpacity(_profileEmailOpacity),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: _sectionSpacing),
          Container(
            padding: _menuPadding,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(_menuCornerRadius),
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
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: _menuChevronSize,
                  ),
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
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: _menuChevronSize,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: _sectionSpacing),
          Container(
            padding: _logoutPadding,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(_logoutCornerRadius),
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
