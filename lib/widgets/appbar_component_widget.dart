import 'package:flutter/material.dart';
import 'package:sleep_tracker/widgets/logout_button.dart';

const _appBarHeight = 72.0;
const _titleSpacing = 20.0;
const _logoSize = 34.0;
const _logoCornerRadius = 12.0;
const _logoIconSize = 18.0;
const _logoTitleSpacing = 12.0;
const _titleLetterSpacing = 0.4;

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
      toolbarHeight: _appBarHeight,
      titleSpacing: _titleSpacing,
      title: Row(
        children: [
          Container(
            width: _logoSize,
            height: _logoSize,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(_logoCornerRadius),
            ),
            child: Icon(
              Icons.bedtime_rounded,
              size: _logoIconSize,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: _logoTitleSpacing),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sleep Tracker',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: _titleLetterSpacing,
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
    return const Size.fromHeight(_appBarHeight);
  }
}
