import 'package:app_database/app_database.dart' show DatabaseService;
import 'package:app_http/app_http.dart' show ServerService;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get_it/get_it.dart';
import 'package:kib_theme_switcher/utils/theme/export.dart';
import 'package:kib_theme_switcher/services/export.dart';

// Global GetIt instance
final getIt = GetIt.instance;

/// Setup all service dependencies
Future<void> setupServiceLocator() async {
  await _setupDatabase();
  _setupServer();
  _setupServices();
}

/// Setup database related dependencies
Future<void> _setupDatabase() async {
  // Register DatabaseService as a singleton
  final databaseService = await DatabaseService.create();
  getIt.registerSingleton<DatabaseService>(databaseService);
}

/// Setup server service with environment-specific configuration
void _setupServer() {
  // Register ServerService as a singleton with environment-specific configuration
  getIt.registerLazySingleton<ServerService>(
        () => kDebugMode
        ? ServerService.development(enableLogging: true)
        : ServerService.production(enableLogging: false),
  );
}

/// Setup services for the project
void _setupServices() {
  _setupThemeServices();
  _setupUserServices();
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

/// Setup User services
void _setupUserServices() {
  // Register UserService as a singleton with required dependencies
  getIt.registerLazySingleton<UserService>(
        () => UserService(
      databaseService: getIt<DatabaseService>(),
      serverService: getIt<ServerService>(),
    ),
  );
}


