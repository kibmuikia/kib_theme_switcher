import 'package:get_it/get_it.dart';
import 'package:app_database/app_database.dart';
import 'package:kib_theme_switcher/utils/theme/export.dart';

// Global GetIt instance
final getIt = GetIt.instance;

/// Setup all service dependencies
Future<void> setupServiceLocator() async {
  await _setupDatabase();
  _setupThemeServices();
}

/// Setup database related dependencies
Future<void> _setupDatabase() async {
  // Register DatabaseService as a singleton
  final databaseService = await DatabaseService.create();
  getIt.registerSingleton<DatabaseService>(databaseService);
}

/// Setup theme related dependencies
void _setupThemeServices() {
  // Register AppTheme as a singleton
  getIt.registerLazySingleton<AppTheme>(() => AppTheme());

  // Register ThemeService as a singleton with DatabaseService dependency
  getIt.registerLazySingleton<ThemeService>(
        () => ThemeService(
      databaseService: getIt<DatabaseService>(),
    ),
  );
}