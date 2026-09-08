import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';
import 'typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: CloverColors.green,
      primary: CloverColors.green,
      secondary: CloverColors.orange,
      surface: CloverColors.surface,
      onSurface: CloverColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'BalooBhai2',
      scaffoldBackgroundColor: CloverColors.surfaceMuted,
      splashFactory: InkSparkle.splashFactory,
      textTheme: TextTheme(
        displayLarge: AppText.hero,
        headlineLarge: AppText.title,
        headlineMedium: AppText.headline,
        titleLarge: AppText.subtitle,
        titleMedium: AppText.section,
        bodyLarge: AppText.bodyStrong,
        bodyMedium: AppText.body,
        labelLarge: AppText.button,
      ),
      dividerColor: CloverColors.border,
      dividerTheme: const DividerThemeData(
        color: CloverColors.border,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: CloverColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: CloverColors.ink,
        titleTextStyle: AppText.cardTitle,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
