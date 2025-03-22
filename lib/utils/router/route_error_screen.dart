import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        Scaffold,
        AppBar,
        Text,
        Center,
        Column,
        MainAxisAlignment,
        TextStyle,
        SizedBox,
        ElevatedButton;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:kib_theme_switcher/utils/router/routes.dart';

/// Screen shown when route is not found or other routing errors occur
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops! The page you\'re looking for doesn\'t exist.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home.path),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
