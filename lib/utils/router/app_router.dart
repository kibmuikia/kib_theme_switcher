import 'package:go_router/go_router.dart';
import 'package:kib_theme_switcher/screens/home.dart';
import 'package:kib_theme_switcher/utils/router/route_error_screen.dart';
import 'package:kib_theme_switcher/utils/router/routes.dart';
import 'package:kib_theme_switcher/utils/router/scaffold_with_navbar.dart';

/// Router configuration for the app
class AppRouter {
  AppRouter._();

  /// Creates and returns a configured [GoRouter] instance
  static GoRouter get router => _router;

  /// The route configuration
  static final _router = GoRouter(
    routes: routes,
    errorBuilder: (context, state) => const RouteErrorScreen(),
    debugLogDiagnostics: true,
  );

  /// The route configuration list
  static final routes = <RouteBase>[
    // Home route
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (context, state) => const MyHomePage(title: 'Home'),
    ),

    // Shell route example for bottom navigation or similar
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: <RouteBase>[
        // Add shell child routes here
      ],
    ),
  ];
}
