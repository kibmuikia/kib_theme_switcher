import 'package:flutter/material.dart'
    show
        BuildContext,
        Icon,
        Icons,
        NavigationBar,
        NavigationDestination,
        Scaffold,
        StatelessWidget,
        Widget;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:kib_theme_switcher/utils/router/routes.dart';

/// Example scaffold with navigation bar
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          // Handle navigation
          switch (index) {
            case 0:
              context.go(AppRoutes.home.path);
              break;
            case 1:
              context.go(AppRoutes.profile.path);
              break;
            // Add more cases as needed
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // Add more destinations as needed
        ],
      ),
    );
  }
}
