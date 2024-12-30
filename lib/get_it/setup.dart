import 'package:get_it/get_it.dart';
import 'package:kib_theme_switcher/utils/theme/export.dart';

// Global GetIt instance
final getIt = GetIt.instance;

/// Setup all service dependencies
void setupServiceLocator() {
  // Register AppTheme as a singleton
  getIt.registerLazySingleton<AppTheme>(() => AppTheme());

  // Register ThemeService as a singleton
  getIt.registerLazySingleton<ThemeService>(() => ThemeService());
}