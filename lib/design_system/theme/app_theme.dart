import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color paper = Color(0xFFF8F7F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF242B33);
  static const Color mutedInk = Color(0xFF626971);
  static const Color navy = Color(0xFF263E59);
  static const Color softRed = Color(0xFFA34C4F);
  static const Color border = Color(0xFFE8E6E1);
}

abstract final class AppSpacing {
  static const double small = 8;
  static const double medium = 16;
  static const double page = 20;
  static const double section = 24;
}

abstract final class AppTheme {
  static TextStyle _serif(
    double size, {
    FontWeight weight = FontWeight.w400,
    FontStyle? style,
  }) => TextStyle(
    fontFamily: 'SourceSerif4',
    height: 1.2,
    fontSize: size,
    fontWeight: weight,
    fontStyle: style,
    color: AppColors.ink,
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: const ColorScheme.light(
      primary: AppColors.navy,
      secondary: AppColors.softRed,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.mutedInk,
      outlineVariant: AppColors.border,
    ),
    textTheme: TextTheme(
      headlineLarge: _serif(32),
      headlineSmall: _serif(22, style: FontStyle.italic),
      titleLarge: _serif(21),
      titleMedium: _serif(17),
      bodyLarge: _serif(16),
      bodyMedium: const TextStyle(
        fontSize: 13,
        height: 1.35,
        color: AppColors.mutedInk,
      ),
      bodySmall: const TextStyle(fontSize: 11, color: AppColors.mutedInk),
      labelSmall: const TextStyle(fontSize: 10, color: AppColors.mutedInk),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.paper,
      selectedItemColor: AppColors.softRed,
      unselectedItemColor: AppColors.mutedInk,
      selectedLabelStyle: TextStyle(fontSize: 11),
      unselectedLabelStyle: TextStyle(fontSize: 11),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
