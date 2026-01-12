import 'package:flutter/material.dart';

const _cardPadding = EdgeInsets.symmetric(horizontal: 28, vertical: 24);
const _cardCornerRadius = 22.0;
const _cardShadowOpacity = 0.08;
const _cardShadowBlur = 18.0;
const _cardShadowOffset = Offset(0, 10);
const _logoSize = 64.0;
const _logoCornerRadius = 20.0;
const _logoIconSize = 34.0;
const _titleSpacing = 14.0;
const _subtitleSpacing = 6.0;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Container(
          padding: _cardPadding,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(_cardCornerRadius),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(_cardShadowOpacity),
                blurRadius: _cardShadowBlur,
                offset: _cardShadowOffset,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  color: colorScheme.onPrimaryContainer,
                  size: _logoIconSize,
                ),
              ),
              const SizedBox(height: _titleSpacing),
              Text(
                'Sleep Tracker',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: _subtitleSpacing),
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
