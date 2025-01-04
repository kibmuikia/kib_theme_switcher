import 'package:app_database/objectbox.g.dart';
import 'package:app_database/models/export.dart' show UserModel;
import 'package:flutter/foundation.dart' show debugPrint;
import 'base.dart';

/// DAO for handling user data persistence and queries
class UserModelDao extends BaseDao<UserModel> {
  /// Constructor
  UserModelDao(this._box);

  final Box<UserModel> _box;

  @override
  Box<UserModel> get box => _box;

  /// Get user by uid
  UserModel? getByUid(String uid) {
    try {
      final query = box.query(UserModel_.uid.equals(uid)).build();
      return query.findFirst();
    } on Exception catch (e) {
      debugPrint('** UserModelDao:getByUid: $e *');
      return null;
    }
  }

  /// Get user by email
  UserModel? getByEmail(String email) {
    try {
      final query = box.query(UserModel_.email.equals(email)).build();
      return query.findFirst();
    } on Exception catch (e) {
      debugPrint('** UserModelDao:getByEmail: $e *');
      return null;
    }
  }

  /// Get all active users
  List<UserModel> getActiveUsers() {
    try {
      final query = box.query(UserModel_.isActive.equals(true))
        ..order(UserModel_.createdAt, flags: Order.descending);
      return query.build().find();
    } on Exception catch (e) {
      debugPrint('** UserModelDao:getActiveUsers: $e *');
      return [];
    }
  }

  /// Save or update user
  /// Returns the ID of the saved/updated user or -1 if operation failed
  int saveUser(UserModel user) {
    try {
      // Check if user already exists by UID
      final existingUser = getByUid(user.uid);
      if (existingUser != null) {
        // Update existing user
        user = user.copyWith(
          createdAt: existingUser.createdAt,
          updatedAt: DateTime.now(),
        );
        return put(user);
      }
      // Create new user
      return put(user);
    } on Exception catch (e) {
      debugPrint('** UserModelDao:saveUser: $e *');
      return -1;
    }
  }

  /// Soft delete a user by setting isActive to false
  /// Returns true if operation was successful
  bool softDeleteUser(String uid) {
    try {
      final user = getByUid(uid);
      if (user != null) {
        final updatedUser = user.copyWith(
          isActive: false,
          updatedAt: DateTime.now(),
        );
        return put(updatedUser) > 0;
      }
      return false;
    } on Exception catch (e) {
      debugPrint('** UserModelDao:softDeleteUser: $e *');
      return false;
    }
  }

  /// Update user's email verification status
  /// Returns true if operation was successful
  bool updateEmailVerification(String uid, bool isVerified) {
    try {
      final user = getByUid(uid);
      if (user != null) {
        final updatedUser = user.copyWith(
          isEmailVerified: isVerified,
          updatedAt: DateTime.now(),
        );
        return put(updatedUser) > 0;
      }
      return false;
    } on Exception catch (e) {
      debugPrint('** UserModelDao:updateEmailVerification: $e *');
      return false;
    }
  }

  /// Update user's profile information
  /// Returns true if operation was successful
  bool updateProfile({
    required String uid,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
  }) {
    try {
      final user = getByUid(uid);
      if (user != null) {
        final updatedUser = user.copyWith(
          displayName: displayName,
          phoneNumber: phoneNumber,
          photoUrl: photoUrl,
          updatedAt: DateTime.now(),
        );
        return put(updatedUser) > 0;
      }
      return false;
    } on Exception catch (e) {
      debugPrint('** UserModelDao:updateProfile: $e *');
      return false;
    }
  }

  /// Search users by display name (case-insensitive)
  List<UserModel> searchByDisplayName(String nameQuery) {
    try {
      final query = box.query(UserModel_.displayName.contains(nameQuery, caseSensitive: false))
        ..order(UserModel_.displayName);
      return query.build().find();
    } on Exception catch (e) {
      debugPrint('** UserModelDao:searchByDisplayName: $e *');
      return [];
    }
  }
}
