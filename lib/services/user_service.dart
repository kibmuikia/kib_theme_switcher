import 'package:app_database/app_database.dart' show DatabaseService, UserModel;
import 'package:app_http/app_http.dart'
    show ApiError, ApiResponse, ServerService, UserEndpoints;
import 'package:flutter/foundation.dart' show debugPrint;

typedef UserResult = ({UserModel? user, Exception? e});

const String invalidId = 'ID cannot be empty';

/// Service to handle user-related operations both locally and remotely
class UserService {
  final DatabaseService _databaseService;
  final ServerService _serverService;

  /// Constructor requiring both database and server services
  UserService({
    required DatabaseService databaseService,
    required ServerService serverService,
  })  : _databaseService = databaseService,
        _serverService = serverService;

  /// Save user data locally
  Future<bool> _saveLocally(UserModel user) async {
    try {
      final result = _databaseService.userModelDao.saveUser(user);
      return result > 0;
    } on Exception catch (e) {
      debugPrint('** UserService:_saveLocally: $e *');
      return false;
    }
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
      debugPrint('** UserService:getLocalUser: $e *');
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
