import 'package:flutter/material.dart';

/// アプリ全体のテーマを集中管理するヘルパー。
class AppTheme {
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF273E63),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD7E2F2),
    onPrimaryContainer: Color(0xFF10243C),
    secondary: Color(0xFFC97557),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFE1D5),
    onSecondaryContainer: Color(0xFF5A2A19),
    tertiary: Color(0xFF4B7B6B),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFDCEFE6),
    onTertiaryContainer: Color(0xFF214236),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1C1B1A),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1C1B1A),
    surfaceVariant: Color(0xFFF4F4F4),
    onSurfaceVariant: Color(0xFF5A5A5A),
    outline: Color(0xFFD6D6D6),
    outlineVariant: Color(0xFFE6E6E6),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF2F2B27),
    onInverseSurface: Color(0xFFF5F0EA),
    inversePrimary: Color(0xFFB7CAE8),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9FB7E3),
    onPrimary: Color(0xFF0C1117),
    primaryContainer: Color(0xFF2A3C58),
    onPrimaryContainer: Color(0xFFE4ECF8),
    secondary: Color(0xFFE39A7C),
    onSecondary: Color(0xFF2B1710),
    secondaryContainer: Color(0xFF5C3A2D),
    onSecondaryContainer: Color(0xFFFDE8DE),
    tertiary: Color(0xFF89BFA7),
    onTertiary: Color(0xFF0E1A16),
    tertiaryContainer: Color(0xFF234238),
    onTertiaryContainer: Color(0xFFCEE6DB),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    background: Color(0xFF000000),
    onBackground: Color(0xFFE8E6E1),
    surface: Color(0xFF0B0B0B),
    onSurface: Color(0xFFE8E6E1),
    surfaceVariant: Color(0xFF161616),
    onSurfaceVariant: Color(0xFFBDBDBD),
    outline: Color(0xFF2A2A2A),
    outlineVariant: Color(0xFF1F1F1F),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE8E6E1),
    onInverseSurface: Color(0xFF151B22),
    inversePrimary: Color(0xFF273E63),
  );

  static TextTheme _buildTextTheme(TextTheme base, ColorScheme colorScheme) {
    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.4),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.45),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    ).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
  }

  static ThemeData light() {
    final textTheme =
        _buildTextTheme(ThemeData.light().textTheme, _lightColorScheme);
    return ThemeData(
      useMaterial3: false,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: _lightColorScheme.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: _lightColorScheme.background,
        foregroundColor: _lightColorScheme.onSurface,
        titleSpacing: 20,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: _lightColorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        color: _lightColorScheme.surface,
        elevation: 0,
        shadowColor: _lightColorScheme.shadow.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: _lightColorScheme.outlineVariant,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _lightColorScheme.surfaceVariant,
        selectedColor: _lightColorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        labelStyle: TextStyle(
          color: _lightColorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(
          color: _lightColorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _lightColorScheme.secondary,
        foregroundColor: _lightColorScheme.onSecondary,
        elevation: 2,
        shape: const StadiumBorder(),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: _lightColorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightColorScheme.primary,
          side: BorderSide(color: _lightColorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: _lightColorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _lightColorScheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightColorScheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightColorScheme.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _lightColorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _lightColorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: _lightColorScheme.primary,
            width: 1.4,
          ),
        ),
        labelStyle: TextStyle(color: _lightColorScheme.onSurfaceVariant),
        helperStyle: TextStyle(color: _lightColorScheme.onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(
        color: _lightColorScheme.outlineVariant,
        thickness: 1,
        space: 24,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: _lightColorScheme.primary,
        textColor: _lightColorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final textTheme =
        _buildTextTheme(ThemeData.dark().textTheme, _darkColorScheme);
    return ThemeData(
      useMaterial3: false,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: _darkColorScheme.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: _darkColorScheme.background,
        foregroundColor: _darkColorScheme.onSurface,
        titleSpacing: 20,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: _darkColorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        color: _darkColorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: _darkColorScheme.outlineVariant,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _darkColorScheme.surfaceVariant,
        selectedColor: _darkColorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        labelStyle: TextStyle(
          color: _darkColorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(
          color: _darkColorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _darkColorScheme.secondary,
        foregroundColor: _darkColorScheme.onSecondary,
        elevation: 2,
        shape: const StadiumBorder(),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _darkColorScheme.primary,
          foregroundColor: _darkColorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkColorScheme.primary,
          side: BorderSide(color: _darkColorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: _darkColorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _darkColorScheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkColorScheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkColorScheme.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _darkColorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _darkColorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: _darkColorScheme.primary,
            width: 1.4,
          ),
        ),
        labelStyle: TextStyle(color: _darkColorScheme.onSurfaceVariant),
        helperStyle: TextStyle(color: _darkColorScheme.onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(
        color: _darkColorScheme.outlineVariant,
        thickness: 1,
        space: 24,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: _darkColorScheme.primary,
        textColor: _darkColorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
