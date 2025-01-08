import 'package:flutter/material.dart' show BuildContext;
import 'package:go_router/go_router.dart' show GoRouterState;
import 'package:kib_theme_switcher/utils/router/routes.dart';

/// Utility functions for route handling
class RouteUtils {
  RouteUtils._();

  /// Check if user is authenticated
  static bool isAuthenticated = false;

  /// Redirect logic for authentication
  static String? authGuard(BuildContext context, GoRouterState state) {
    if (!isAuthenticated) {
      return AppRoutes.login.path;
    }
    return null;
  }

  /// Get route name from path
  static String? getRouteName(String path) {
    final route = AppRoutes.values.firstWhere(
          (route) => route.path == path,
      orElse: () => AppRoutes.home,
    );
    return route.name;
  }
}
