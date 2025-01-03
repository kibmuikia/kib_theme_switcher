import 'package:flutter/material.dart' show AppBarTheme, BorderRadius, Brightness, CardTheme, Color, ColorScheme, EdgeInsets, ElevatedButton, ElevatedButtonThemeData, FontWeight, RoundedRectangleBorder, TextStyle, TextTheme, ThemeData;

import 'app_colors.dart';

class AppTheme {
  // Singleton instance
  static final AppTheme _instance = AppTheme._internal();

  // Factory constructor
  factory AppTheme() {
    return _instance;
  }

  // Private constructor
  AppTheme._internal();

  // Typography configuration
  static const String _fontFamily = 'Fabiolo';  // From design system

  // Theme getter methods
  ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      colors: AppColors.lightTheme,
    );
  }

  ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      colors: AppColors.darkTheme,
    );
  }

  // Helper method to build theme data
  ThemeData _buildTheme({
    required Brightness brightness,
    required Map<String, Color> colors,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: _fontFamily,

      // Color Scheme
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors['primary']!,
        onPrimary: colors['onPrimary']!,
        secondary: colors['secondary']!,
        onSecondary: colors['onSecondary']!,
        error: colors['error']!,
        onError: colors['onError']!,
        surface: colors['surface']!,
        onSurface: colors['onSurface']!,
      ),

      // Component themes
      appBarTheme: AppBarTheme(
        backgroundColor: colors['surface'],
        foregroundColor: colors['text'],
        elevation: 0,
      ),

      // Card theme
      cardTheme: CardTheme(
        color: colors['surface'],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: colors['onPrimary'],
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: colors['text'],
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: colors['text'],
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: colors['text'],
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: colors['text'],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
