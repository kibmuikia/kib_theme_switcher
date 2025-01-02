/// API version enum for type-safe version handling
enum ApiVersion {
  v1('v1'),
  v2('v2');

  final String value;

  const ApiVersion(this.value);
}

/// Categorizes different endpoint groups
enum EndpointCategory {
  auth('auth'),
  users('users'),
  posts('posts'),
  comments('comments');

  final String value;

  const EndpointCategory(this.value);
}

/// Main API path builder that constructs endpoint URLs
class ApiPath {
  final ApiVersion version;
  final EndpointCategory category;
  final String path;

  const ApiPath._(this.version, this.category, this.path);

  String build() => '/${version.value}/${category.value}/$path';

  @override
  String toString() => build();

  // Auth endpoints
  static const login =
      ApiPath._(ApiVersion.v1, EndpointCategory.auth, '/login');
  static const register =
      ApiPath._(ApiVersion.v1, EndpointCategory.auth, '/register');

  // User endpoints
  static const userProfile =
      ApiPath._(ApiVersion.v1, EndpointCategory.users, '/profile');
  static const userSettings =
      ApiPath._(ApiVersion.v1, EndpointCategory.users, '/settings');

  // Post endpoints
  static const posts = ApiPath._(ApiVersion.v1, EndpointCategory.posts, '');

  static postById(String id) =>
      ApiPath._(ApiVersion.v1, EndpointCategory.posts, '/$id');
}
