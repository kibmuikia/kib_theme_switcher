import 'package:equatable/equatable.dart' show EquatableConfig;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:kib_debug_print/kib_debug_print.dart' show DebugPrintService;
import 'package:kib_theme_switcher/common_export.dart'
    show ThemeService, getIt, setupServiceLocator, LoginScreen;

/*
 * Sets the EquatableConfig stringify value.
 * 
 * @param {boolean} value - The value to set for EquatableConfig.stringify.
 * @returns {void}
 * 
 * If stringify is overridden for a specific Equatable class, 
 * then the value of EquatableConfig.stringify is ignored. 
 * In other words, the local configuration always takes precedence over the global configuration.
 * Note: EquatableConfig.stringify defaults to true in debug mode and false in release mode.
 */
void setEquatableConfigStringify(value) {
  EquatableConfig.stringify = value;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DebugPrintService.initialize();

  // Initialize service locator
  await setupServiceLocator();

  
  setEquatableConfigStringify(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = getIt<ThemeService>();

    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeService.themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: kDebugMode,
          title: 'Kib Switcher',
          theme: theme,
          // home: const MyHomePage(title: 'The Switcher'),
          // home: const SignupScreen(),
          home: const LoginScreen(),
        );
      },
    );
  }
}
