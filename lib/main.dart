import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:kib_theme_switcher/common_export.dart'
    show DebugPrintService, MyHomePage, ThemeService, getIt, setupServiceLocator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DebugPrintService.initialize();
  // Initialize service locator
  await setupServiceLocator();

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
          home: const MyHomePage(title: 'The Switcharoo'),
        );
      },
    );
  }
}
