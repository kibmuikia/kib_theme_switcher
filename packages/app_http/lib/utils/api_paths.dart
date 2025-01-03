/// Represents different API versions
enum ApiVersion {
  v1('v1'),
  v2('v2'),
  beta('beta');

  final String value;

  const ApiVersion(this.value);
}

/// Represents different resource categories
enum ResourceType {
  auth('auth'),
  users('users'),
  posts('posts'),
  comments('comments'),
  media('media'),
  notifications('notifications');

  final String value;

  const ResourceType(this.value);
}

/// Abstract base class that provides core functionality for building and manipulating API endpoint URLs.
///
/// This class serves as the foundation for all API endpoint definitions in the system.
/// It provides methods for constructing endpoint paths and handling both query and path parameters.
///
/// Example usage:
/// ```dart
/// // Simple endpoint construction
/// final profileUrl = UserEndpoints.profile.build();
/// // Result: /v1/users/profile
///
/// // Using path parameters
/// final userUrl = UserEndpoints.userById.withParams({'userId': '123'});
/// // Result: /v1/users/123
///
/// // Using query parameters
/// final postsUrl = PostEndpoints.trending.withQuery({
///   'page': 1,
///   'limit': 10,
///   'sort': 'recent'
/// });
/// // Result: /v2/posts/trending?page=1&limit=10&sort=recent
/// ```
abstract class BaseEndpoint {
  /// The API version this endpoint belongs to (e.g., v1, v2, beta)
  final ApiVersion version;

  /// The resource category this endpoint belongs to (e.g., users, posts)
  final ResourceType resource;

  /// The specific path segment for this endpoint
  /// Can include path parameters denoted by colon prefix (e.g., ':userId')
  final String path;

  /// Whether this endpoint requires authentication
  /// Defaults to true as most endpoints require auth
  final bool requiresAuth;

  /// Creates a new endpoint with the specified configuration.
  ///
  /// [version] and [resource] define the base path structure.
  /// [path] specifies the endpoint-specific path segment.
  /// [requiresAuth] indicates if the endpoint needs authentication.
  const BaseEndpoint({
    required this.version,
    required this.resource,
    required this.path,
    this.requiresAuth = true,
  });

  /// Builds the complete endpoint path by combining version, resource and path segments.
  ///
  /// Returns a URL path in the format:
  /// - With path: /{version}/{resource}/{path}
  /// - Without path: /{version}/{resource}
  ///
  /// Example:
  /// ```dart
  /// final endpoint = UserEndpoints.profile.build();
  /// // Returns: /v1/users/profile
  /// ```
  String build() => path.isEmpty
      ? '/${version.value}/${resource.value}'
      : '/${version.value}/${resource.value}/$path';

  @override
  String toString() => build();

  /// Appends query parameters to the endpoint URL.
  ///
  /// [params] - Map of query parameter names to their values
  ///
  /// Returns the complete URL with encoded query parameters.
  /// If [params] is empty, returns the basic endpoint URL.
  ///
  /// Example:
  /// ```dart
  /// final url = PostEndpoints.trending.withQuery({
  ///   'page': 1,
  ///   'limit': 10,
  ///   'sort': 'recent'
  /// });
  /// // Returns: /v2/posts/trending?page=1&limit=10&sort=recent
  /// ```
  String withQuery(Map<String, dynamic> params) {
    if (params.isEmpty) return build();

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    return '${build()}?$queryString';
  }

  /// Replaces path parameters in the endpoint URL with provided values.
  ///
  /// [params] - Map of parameter names to their replacement values
  ///
  /// Returns the URL with all path parameters replaced.
  /// Path parameters in the URL must be prefixed with ':' to be replaced.
  ///
  /// Example:
  /// ```dart
  /// final url = UserEndpoints.userById.withParams({'userId': '123'});
  /// // Returns: /v1/users/123
  ///
  /// final nestedUrl = UserEndpoints.userPosts.withParams({'userId': '123'});
  /// // Returns: /v1/users/123/posts
  /// ```
  String withParams(Map<String, dynamic> params) {
    String finalPath = build();
    params.forEach((key, value) {
      finalPath = finalPath.replaceAll(':$key', value.toString());
    });
    return finalPath;
  }
}

/// Authentication related endpoints
class AuthEndpoints {
  static const login = _AuthEndpoint(
    path: 'login',
    requiresAuth: false,
  );

  static const register = _AuthEndpoint(
    path: 'register',
    requiresAuth: false,
  );

  static const refreshToken = _AuthEndpoint(
    path: 'refresh',
  );

  static const logout = _AuthEndpoint(
    path: 'logout',
  );
}

class _AuthEndpoint extends BaseEndpoint {
  const _AuthEndpoint({
    required super.path,
    super.requiresAuth,
  }) : super(
          version: ApiVersion.v1,
          resource: ResourceType.auth,
        );
}

/// User related endpoints
class UserEndpoints {
  static const profile = _UserEndpoint('profile');
  static const settings = _UserEndpoint('settings');
  static const preferences = _UserEndpoint('preferences');

  // Endpoint with path parameter
  static const userById = _UserEndpoint(':userId');

  // Nested resource endpoint
  static const userPosts = _UserEndpoint(':userId/posts');
}

class _UserEndpoint extends BaseEndpoint {
  const _UserEndpoint(String path)
      : super(
          version: ApiVersion.v1,
          resource: ResourceType.users,
          path: path,
        );
}

/// Post related endpoints
class PostEndpoints {
  static const all = _PostEndpoint('');
  static const create = _PostEndpoint('');
  static const postById = _PostEndpoint(':postId');
  static const comments = _PostEndpoint(':postId/comments');
  static const likes = _PostEndpoint(':postId/likes');

  // V2 endpoints
  static const trending = _PostEndpoint(
    'trending',
    version: ApiVersion.v2,
  );
}

class _PostEndpoint extends BaseEndpoint {
  const _PostEndpoint(
    String path, {
    super.version = ApiVersion.v1,
    super.requiresAuth,
  }) : super(
          resource: ResourceType.posts,
          path: path,
        );
}
