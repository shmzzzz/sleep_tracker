import 'package:flutter/material.dart';

class UiConstants {
  const UiConstants._();

  // Auth screen
  static const EdgeInsets authPagePadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 24);
  static const double authLogoSize = 68.0;
  static const double authLogoCornerRadius = 22.0;
  static const double authLogoIconSize = 36.0;
  static const double authTitleSpacing = 16.0;
  static const double authSubtitleSpacing = 8.0;
  static const double authSectionSpacing = 24.0;
  static const EdgeInsets authCardPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 28);
  static const double authCardCornerRadius = 22.0;
  static const double authCardShadowOpacity = 0.08;
  static const double authCardShadowBlur = 16.0;
  static const Offset authCardShadowOffset = Offset(0, 8);
  static const Duration authProgressFadeDuration =
      Duration(milliseconds: 250);
  static const double authFieldSpacing = 16.0;
  static const double authButtonSpacing = 24.0;
  static const double authToggleSpacing = 12.0;
  static const int authMinPasswordLength = 6;

  // Sleep add/edit form
  static const int sleepFormDateRangeYears = 5;
  static const EdgeInsets sleepFormPagePadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 24);
  static const double sleepFormHeaderSpacing = 8.0;
  static const double sleepFormSectionSpacing = 20.0;
  static const double sleepFormSectionSpacingLarge = 24.0;
  static const double sleepFormCardSpacing = 18.0;
  static const double sleepFormFieldSpacing = 18.0;
  static const double sleepFormButtonTopSpacing = 28.0;
  static const double sleepFormButtonSpacing = 12.0;
  static const EdgeInsets sleepFormPrimaryButtonPadding =
      EdgeInsets.symmetric(horizontal: 26, vertical: 14);
  static const EdgeInsets sleepFormSecondaryButtonPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 12);
  static const EdgeInsets sleepFormPreviewPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 18);
  static const double sleepFormPreviewCornerRadius = 20.0;
  static const double sleepFormPreviewShadowOpacity = 0.06;
  static const double sleepFormPreviewShadowBlur = 14.0;
  static const Offset sleepFormPreviewShadowOffset = Offset(0, 8);
  static const double sleepFormPreviewStatusIconSize = 28.0;
  static const double sleepFormPreviewStatusSpacing = 12.0;
  static const double sleepFormPreviewMetricsSpacing = 18.0;
  static const double sleepFormMetricSpacing = 6.0;
  static const double sleepFormMetricLabelOpacity = 0.75;
  static const double sleepFormDateTileCornerRadius = 18.0;
  static const EdgeInsets sleepFormDateTilePadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 4);

  // Sleep list screen
  static const EdgeInsets sleepListBottomPadding =
      EdgeInsets.only(bottom: 96);
  static const EdgeInsets sleepListFabPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 14);
  static const EdgeInsets sleepListEmptyStatePadding =
      EdgeInsets.symmetric(horizontal: 32, vertical: 40);
  static const double sleepListEmptyStateIconSize = 64.0;
  static const double sleepListEmptyStateTitleSpacing = 16.0;
  static const double sleepListEmptyStateBodySpacing = 8.0;
  static const double sleepListEmptyStateButtonSpacing = 24.0;
  static const double sleepListErrorIconSize = 48.0;
  static const double sleepListErrorTitleSpacing = 12.0;
  static const double sleepListErrorBodySpacing = 8.0;

  // Splash screen
  static const EdgeInsets splashCardPadding =
      EdgeInsets.symmetric(horizontal: 28, vertical: 24);
  static const double splashCardCornerRadius = 22.0;
  static const double splashCardShadowOpacity = 0.08;
  static const double splashCardShadowBlur = 18.0;
  static const Offset splashCardShadowOffset = Offset(0, 10);
  static const double splashLogoSize = 64.0;
  static const double splashLogoCornerRadius = 20.0;
  static const double splashLogoIconSize = 34.0;
  static const double splashTitleSpacing = 14.0;
  static const double splashSubtitleSpacing = 6.0;

  // App bar
  static const double appBarHeight = 72.0;
  static const double appBarTitleSpacing = 20.0;
  static const double appBarLogoSize = 34.0;
  static const double appBarLogoCornerRadius = 12.0;
  static const double appBarLogoIconSize = 18.0;
  static const double appBarLogoTitleSpacing = 12.0;
  static const double appBarTitleLetterSpacing = 0.4;

  // Drawer
  static const EdgeInsets drawerPadding = EdgeInsets.fromLTRB(20, 24, 20, 16);
  static const EdgeInsets drawerProfilePadding =
      EdgeInsets.fromLTRB(18, 18, 18, 16);
  static const double drawerProfileCornerRadius = 20.0;
  static const double drawerProfileIconSize = 44.0;
  static const double drawerProfileIconCornerRadius = 14.0;
  static const double drawerProfileTitleSpacing = 12.0;
  static const double drawerProfileEmailSpacing = 4.0;
  static const double drawerProfileIconOpacity = 0.2;
  static const double drawerProfileEmailOpacity = 0.85;
  static const double drawerSectionSpacing = 20.0;
  static const EdgeInsets drawerMenuPadding = EdgeInsets.all(6);
  static const double drawerMenuCornerRadius = 18.0;
  static const double drawerMenuChevronSize = 16.0;
  static const EdgeInsets drawerLogoutPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  static const double drawerLogoutCornerRadius = 18.0;

  // Logout button
  static const double logoutIconSize = 18.0;
  static const EdgeInsets logoutPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 10);

  // Sleep list item
  static const EdgeInsets sleepListItemPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const double sleepListItemCornerRadius = 20.0;
  static const double sleepListItemShadowOpacity = 0.08;
  static const double sleepListItemShadowBlur = 12.0;
  static const Offset sleepListItemShadowOffset = Offset(0, 6);
  static const EdgeInsets sleepListItemInnerPadding =
      EdgeInsets.fromLTRB(18, 16, 18, 18);
  static const double sleepListItemAvatarRadius = 22.0;
  static const double sleepListItemAvatarSpacing = 16.0;
  static const double sleepListItemTitleSpacing = 4.0;
  static const double sleepListItemGoalIconSize = 18.0;
  static const double sleepListItemGoalSpacing = 6.0;
  static const double sleepListItemSectionSpacing = 16.0;
  static const double sleepListItemChipSpacing = 12.0;
  static const EdgeInsets sleepListItemChipPadding =
      EdgeInsets.symmetric(horizontal: 14, vertical: 10);
  static const double sleepListItemChipCornerRadius = 14.0;
  static const double sleepListItemChipIconSize = 18.0;
  static const double sleepListItemChipIconSpacing = 8.0;
  static const double sleepListItemChipBackgroundOpacity = 0.14;
  static const double sleepListItemChipBorderOpacity = 0.35;
  static const double sleepListItemChipLabelOpacity = 0.75;

  // Statistics overview
  static const EdgeInsets statisticsHeaderPadding =
      EdgeInsets.fromLTRB(20, 20, 20, 12);
  static const EdgeInsets statisticsPanelMargin =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const EdgeInsets statisticsPanelPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 18);
  static const double statisticsPanelCornerRadius = 20.0;
  static const double statisticsPanelSpacing = 12.0;
  static const double statisticsPanelGradientOpacity = 0.65;
  static const double statisticsMetricChipSpacing = 12.0;
  static const EdgeInsets statisticsChartPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 12);
  static const double statisticsChartCornerRadius = 20.0;
  static const EdgeInsets statisticsChartTitlePadding =
      EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets statisticsChipPadding =
      EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const double statisticsChipCornerRadius = 16.0;
  static const double statisticsChipDotSize = 8.0;
  static const double statisticsChipDotSpacing = 6.0;
  static const double statisticsChipValueSpacing = 4.0;
  static const double statisticsChipLabelLetterSpacing = 0.1;
  static const double statisticsChipBackgroundOpacity = 0.14;
  static const double statisticsChipBorderOpacity = 0.35;

  // Trend chart
  static const EdgeInsets trendChartEmptyStatePadding =
      EdgeInsets.symmetric(vertical: 16);
  static const int trendChartMinDataPoints = 2;
  static const double trendChartAspectRatio = 1.5;
  static const EdgeInsets trendChartPadding =
      EdgeInsets.only(top: 12, right: 12, left: 6, bottom: 8);
  static const double trendChartYAxisPadding = 0.5;
  static const int trendChartMaxHoursPerDay = 24;
  static const double trendChartLeftTitleReservedSize = 44.0;
  static const double trendChartBottomTitleReservedSize = 32.0;
  static const double trendChartBottomTitleSpacing = 8.0;
  static const double trendChartGridInterval = 1.0;
  static const double trendChartGridStrokeWidth = 0.7;
  static const List<int> trendChartGridDashArray = [4, 4];
  static const double trendChartGridLineOpacity = 0.6;
  static const double trendChartAxisLineOpacity = 0.4;
  static const double trendChartLineBarWidth = 3.0;
  static const double trendChartDotRadius = 3.2;
  static const double trendChartDotStrokeWidth = 1.6;
  static const double trendChartAreaOpacityStart = 0.2;
  static const double trendChartAreaOpacityEnd = 0.02;

  // Time form fields
  static const EdgeInsets timeFieldContentPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);
}
