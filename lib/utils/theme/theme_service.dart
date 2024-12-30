import 'package:flutter/material.dart' show ThemeData, ValueNotifier;
import 'package:kib_theme_switcher/utils/theme/app_theme.dart';

/// Service to manage theme state and preferences
class ThemeService {
  // Internal state
  bool _isDarkMode = false;
  final _themeController = ValueNotifier<ThemeData>(AppTheme().lightTheme);

  // Public interface
  bool get isDarkMode => _isDarkMode;
  ValueNotifier<ThemeData> get themeNotifier => _themeController;
  ThemeData get currentTheme => _themeController.value;

  /// Toggle between light and dark theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeController.value = _isDarkMode ? AppTheme().darkTheme : AppTheme().lightTheme;
  }

  /// Set specific theme mode
  void setThemeMode(bool darkMode) {
    if (_isDarkMode != darkMode) {
      _isDarkMode = darkMode;
      _themeController.value = _isDarkMode ? AppTheme().darkTheme : AppTheme().lightTheme;
    }
  }
}
