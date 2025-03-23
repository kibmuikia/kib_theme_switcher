import 'package:app_database/app_database.dart' show DatabaseService, UserModel;
import 'package:app_http/app_http.dart' show ServerService, UserEndpoints;
import 'package:app_prefs/app_prefs.dart' show AuthPrefsManager;
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;

typedef UserResult = ({UserModel? user, Exception? e});

const String invalidId = 'ID cannot be empty';

/// Service to handle user-related operations both locally and remotely
class UserService {
  final DatabaseService _databaseService;
  final ServerService _serverService;
  final AuthPrefsManager _authPrefs;

  /// Constructor requiring database, server and preferences services
  UserService({
    required DatabaseService databaseService,
    required ServerService serverService,
    required AuthPrefsManager authPrefs,
  })  : _databaseService = databaseService,
        _serverService = serverService,
        _authPrefs = authPrefs;

  /// Check if user is authenticated
  Future<bool> get isAuthenticated async {
    final token = await _authPrefs.getToken();
    final userId = await _authPrefs.getUserId();
    return token != null && userId != null;
  }

  /// Save user data locally
  Future<bool> _saveLocally(UserModel user) async {
    try {
      final result = _databaseService.userModelDao.saveUser(user);
      return result > 0;
    } on Exception catch (e) {
      kprint.err('UserService:_saveLocally: $e');
      return false;
    }
  }

  /// Save user authentication state
  Future<bool> _saveAuthState(String userId, String token) async {
    try {
      final results = await Future.wait([
        _authPrefs.setUserId(userId),
        _authPrefs.setToken(token),
      ]);
      return !results.contains(false);
    } on Exception catch (e) {
      kprint.err('UserService:_saveAuthState: $e');
      return false;
    }
  }

  /// Clear authentication state on logout
  Future<void> logout() async {
    try {
      await Future.wait([
        _authPrefs.clearToken(),
        _authPrefs.setUserId(''),
      ]);
    } on Exception catch (e) {
      kprint.err('UserService:logout: $e');
    }
  }

  /// Get current authenticated user
  Future<UserResult> getCurrentUser() async {
    final userId = await _authPrefs.getUserId();
    if (userId == null) {
      return (user: null, e: Exception('No authenticated user'));
    }
    return getLocalUser(userId);
  }

  /// Get local user by uid
  UserResult getLocalUser(String uid) {
    try {
      if (uid.isEmpty) {
        return (user: null, e: Exception(invalidId));
      }
      final user = _databaseService.userModelDao.getByUid(uid);
      if (user == null) {
        return (user: null, e: Exception('User[$uid] Not Found'));
      }
      return (user: user, e: null);
    } on Exception catch (e) {
      kprint.err('UserService:getLocalUser: $e');
      return (user: null, e: e);
    }
  }

  /// Get remote user profile
  Future<UserResult> getRemoteUser(String uid) async {
    if (uid.isEmpty) {
      return (user: null, e: Exception(invalidId));
    }

    String path = "";
    UserModel? gotUser;

    try {
      path = UserEndpoints.userById.withParams({'userId': uid});
      final response = await _serverService.get<Map<String, dynamic>>(
        path,
      );
      final Map<String, dynamic>? data = response.data;

      if (!response.success || data == null) {
        return (
          user: null,
          e: response.apiError ??
              Exception(response.message ?? 'Failed to fetch user')
        );
      }

      try {
        gotUser = UserModel.fromJson(data);

        await _saveLocally(gotUser);
        await _saveAuthState(gotUser.uid, "sampleToken");

        return (user: gotUser, e: null);
      } on Exception catch (e) {
        return (
          user: null,
          e: Exception('Failed to parse user data: ${e.toString()}')
        );
      }
    } on Exception catch (e) {
      return (user: gotUser, e: e);
    }
  }

//
}
