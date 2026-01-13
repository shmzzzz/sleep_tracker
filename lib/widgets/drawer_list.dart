import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/screens/sleep_add.dart';
import 'package:sleep_tracker/screens/sleep_list.dart';
import 'package:sleep_tracker/widgets/logout_button.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

class DrawerList extends StatelessWidget {
  const DrawerList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: UiConstants.drawerPadding,
        children: [
          Container(
            padding: UiConstants.drawerProfilePadding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(UiConstants.drawerProfileCornerRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: UiConstants.drawerProfileIconSize,
                  height: UiConstants.drawerProfileIconSize,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withOpacity(
                        UiConstants.drawerProfileIconOpacity),
                    borderRadius: BorderRadius.circular(
                        UiConstants.drawerProfileIconCornerRadius),
                  ),
                  child: Icon(
                    Icons.nightlight_round,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: UiConstants.drawerProfileTitleSpacing),
                Text(
                  'Sleep Tracker',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: UiConstants.drawerProfileEmailSpacing),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary
                            .withOpacity(UiConstants.drawerProfileEmailOpacity),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: UiConstants.drawerSectionSpacing),
          Container(
            padding: UiConstants.drawerMenuPadding,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  BorderRadius.circular(UiConstants.drawerMenuCornerRadius),
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
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      size: UiConstants.drawerMenuChevronSize),
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
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      size: UiConstants.drawerMenuChevronSize),
                ),
              ],
            ),
          ),
          const SizedBox(height: UiConstants.drawerSectionSpacing),
          Container(
            padding: UiConstants.drawerLogoutPadding,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  BorderRadius.circular(UiConstants.drawerLogoutCornerRadius),
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
