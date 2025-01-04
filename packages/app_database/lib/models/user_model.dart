import 'dart:convert' show jsonEncode;

import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'user_model.g.dart';

@Entity()
@JsonSerializable()
class UserModel {
  @Id()
  int id;

  /// Unique identifier from authentication provider
  @Unique()
  @JsonKey(required: true)
  String uid;

  /// User's email address
  @Unique()
  @JsonKey(required: true)
  String email;

  /// User's display name
  @JsonKey(includeIfNull: false, name: 'display_name')
  String? displayName;

  /// User's phone number
  @JsonKey(includeIfNull: false, name: 'phone_number')
  String? phoneNumber;

  /// URL to user's profile photo
  @JsonKey(includeIfNull: false, name: 'photo_url')
  String? photoUrl;

  /// Whether the user's email is verified
  @JsonKey(defaultValue: false, name: 'is_email_verified')
  bool isEmailVerified;

  /// Whether the user account is active
  @JsonKey(defaultValue: false, name: 'is_active')
  bool isActive;

  /// Last time user data was updated
  @Property(type: PropertyType.date)
  @JsonKey(
    toJson: _dateToJson,
    fromJson: _dateFromJson,
  )
  DateTime updatedAt;

  /// When the user was created
  @Property(type: PropertyType.date)
  @JsonKey(
    toJson: _dateToJson,
    fromJson: _dateFromJson,
  )
  DateTime createdAt;

  // Constructor with named parameters
  UserModel({
    this.id = 0,
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.isEmailVerified = false,
    this.isActive = true,
    DateTime? updatedAt,
    DateTime? createdAt,
  })  : updatedAt = updatedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  // JSON serialization methods
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  // Helper methods for DateTime JSON conversion
  static String _dateToJson(DateTime date) => date.toIso8601String();

  static DateTime _dateFromJson(String date) => DateTime.parse(date);

  // Copy with method for immutable updates
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    bool? isEmailVerified,
    bool? isActive,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
