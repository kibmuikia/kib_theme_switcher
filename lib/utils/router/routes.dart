/// Route names and paths
enum AppRoutes {
  // Base routes
  home('/', 'home'),
  login('/login', 'login'),
  register('/register', 'register'),

  // User routes
  profile('/profile', 'profile'),
  settings('/settings', 'settings'),

  // Content routes
  feed('/feed', 'feed'),
  details('/details/:id', 'details');

  final String path;
  final String name;

  const AppRoutes(this.path, this.name);

  /// Convert path parameters to actual values
  String withParams(Map<String, String> params) {
    String updatedPath = path;
    params.forEach((key, value) {
      updatedPath = updatedPath.replaceAll(':$key', value);
    });
    return updatedPath;
  }

  /// Add query parameters to path
  String withQuery(Map<String, String> queryParams) {
    if (queryParams.isEmpty) return path;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$path?$queryString';
  }
}
