import 'package:app_database/app_database.dart' show DatabaseService, UserModel;
import 'package:app_http/app_http.dart'
    show ApiError, ApiResponse, ServerService, UserEndpoints;
import 'package:flutter/foundation.dart' show debugPrint;

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

  /// Get local user by uid
  UserModel? getLocalUser(String uid) {
    try {
      return _databaseService.userModelDao.getByUid(uid);
    } on Exception catch (e) {
      debugPrint('** UserService:getLocalUser: $e *');
      return null;
    }
  }

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

  /// Get remote user profile
  Future<ApiResponse<UserModel>?> getRemoteUser(String uid) async {
    final String path = UserEndpoints.userById.withParams({'userId': uid});
    ApiResponse<UserModel>? response;
    try {
      response = await _serverService.get<UserModel>(
        path,
      );
      if (response.success && response.data != null) {
        final user = response.data!;
        // Save to local database
        await _saveLocally(user);
      }
      return response;
    } on Exception catch (e) {
      debugPrint('** UserService:getRemoteUser: $e *');
      return ApiResponse.error(
        url: path,
        message: e.toString(),
        apiError: ApiError(url: path, message: e.toString(), error: e),
      );
    }
  }

//
}
