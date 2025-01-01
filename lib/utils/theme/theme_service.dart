import 'package:app_database/app_database.dart';
import 'package:flutter/material.dart'
    show ThemeData, ValueNotifier, debugPrint;
import 'package:kib_theme_switcher/utils/theme/app_theme.dart';

// enum ThemeMode { light, dark, system, unknown }

/// Service to manage theme state and preferences
class ThemeService {
  final DatabaseService databaseService;

  // Internal state
  bool _isDarkMode = false;
  final _themeController = ValueNotifier<ThemeData>(AppTheme().lightTheme);

  // Public interface
  bool get isDarkMode => _isDarkMode;

  ValueNotifier<ThemeData> get themeNotifier => _themeController;

  ThemeData get currentTheme => _themeController.value;

  ThemeService({required this.databaseService}) {
    _initTheme();
  }

  Future<void> _initTheme() async {
    try {
      // Get the saved theme mode from database
      final savedThemeMode = databaseService.themeModeDao.getCurrentThemeMode();
      _isDarkMode = savedThemeMode?.mode == 'dark';
      final initialTheme = savedThemeMode?.mode == 'dark'
          ? AppTheme().darkTheme
          : AppTheme().lightTheme;
      _themeController.value = initialTheme;
    } on Exception catch (e) {
      debugPrint('**ThemeService:_initTheme: $e *');
      // Fallback in case of an error
      _isDarkMode = false; // Default to light mode
      _themeController.value = AppTheme().lightTheme;
    }
  }

  /// Toggle between light and dark theme
  void toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      _themeController.value =
          _isDarkMode ? AppTheme().darkTheme : AppTheme().lightTheme;
      // Save to database
      databaseService.themeModeDao
          .saveThemeMode(_isDarkMode ? 'dark' : 'light');
    } on Exception catch (e, trace) {
      debugPrint('** ThemeService:toggleTheme: $e, \n$trace *');
    }
  }

  /// Set specific theme mode
  void setThemeMode(bool darkMode) async {
    try {
      if (_isDarkMode != darkMode) {
        _isDarkMode = darkMode;
        _themeController.value =
            _isDarkMode ? AppTheme().darkTheme : AppTheme().lightTheme;
        // Save to database
        databaseService.themeModeDao
            .saveThemeMode(_isDarkMode ? 'dark' : 'light');
      }
    } on Exception catch (e, trace) {
      debugPrint(
          '** ThemeService:setThemeMode: darkMode[$darkMode] $e, \n$trace *');
    }
  }
}
