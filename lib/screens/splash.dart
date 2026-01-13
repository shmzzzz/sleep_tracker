import 'package:flutter/material.dart';
import 'package:sleep_tracker/utils/ui_constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Container(
          padding: UiConstants.splashCardPadding,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius:
                BorderRadius.circular(UiConstants.splashCardCornerRadius),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(
                    UiConstants.splashCardShadowOpacity),
                blurRadius: UiConstants.splashCardShadowBlur,
                offset: UiConstants.splashCardShadowOffset,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: UiConstants.splashLogoSize,
                height: UiConstants.splashLogoSize,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius:
                      BorderRadius.circular(UiConstants.splashLogoCornerRadius),
                ),
                child: Icon(
                  Icons.bedtime_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: UiConstants.splashLogoIconSize,
                ),
              ),
              const SizedBox(height: UiConstants.splashTitleSpacing),
              Text(
                'Sleep Tracker',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: UiConstants.splashSubtitleSpacing),
              Text(
                'Loading your sleep insights...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
