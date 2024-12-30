import 'package:flutter/material.dart';

/// Color constants used throughout the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Core palette colors from design
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFEFEFF0);
  static const Color navyBlue = Color(0xFF393E52);
  static const Color purple = Color(0xFF6747E9);
  static const Color amber = Color(0xFFFFC107);
  static const Color black = Color(0xFF0B0406);

  // Theme color mappings
  static const Map<String, Color> lightTheme = {
    'primary': purple,
    'secondary': amber,
    'background': white,
    'surface': offWhite,
    'error': Color(0xFFB3261E),
    'text': black,
    'onPrimary': white,
    'onSecondary': black,
    'onBackground': black,
    'onSurface': black,
    'onError': white,
  };

  // Dark theme colors - generated to complement light theme
  static const Map<String, Color> darkTheme = {
    'primary': Color(0xFF9E8CFF),  // Lighter purple for dark theme
    'secondary': Color(0xFFFFD88A), // Lighter amber for dark theme
    'background': Color(0xFF121212),
    'surface': Color(0xFF1E1E1E),
    'error': Color(0xFFCF6679),
    'text': white,
    'onPrimary': black,
    'onSecondary': black,
    'onBackground': white,
    'onSurface': white,
    'onError': black,
  };
}