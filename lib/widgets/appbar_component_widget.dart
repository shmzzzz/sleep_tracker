import 'package:flutter/material.dart';
import 'package:sleep_tracker/widgets/logout_button.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

class AppBarComponentWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarComponentWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      toolbarHeight: UiConstants.appBarHeight,
      titleSpacing: UiConstants.appBarTitleSpacing,
      title: Row(
        children: [
          Container(
            width: UiConstants.appBarLogoSize,
            height: UiConstants.appBarLogoSize,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius:
                  BorderRadius.circular(UiConstants.appBarLogoCornerRadius),
            ),
            child: Icon(
              Icons.bedtime_rounded,
              size: UiConstants.appBarLogoIconSize,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: UiConstants.appBarLogoTitleSpacing),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sleep Tracker',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: UiConstants.appBarTitleLetterSpacing,
                ),
              ),
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: const [
        LogoutButton(compact: true),
      ],
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(UiConstants.appBarHeight);
  }
}
