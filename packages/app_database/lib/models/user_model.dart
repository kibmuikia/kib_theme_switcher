import 'dart:convert' show jsonEncode;

import 'package:app_database/models/model_ids.dart' show ModelId;
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'user_model.g.dart';

@Entity(uid: ModelId.userModel)
@JsonSerializable()
class UserModel {
  @Id()
  @Property(uid: 8929599031356645993)
  int autoId;

  /// Unique identifier from authentication provider
  @Unique()
  @JsonKey(required: true)
  @Property(uid: 8894498818730468214)
  String uid;

  /// User's email address
  @Unique()
  @JsonKey(required: true)
  @Property(uid: 3686505616528521774)
  String email;

  /// User's display name
  @JsonKey(includeIfNull: false, name: 'display_name')
  @Property(uid: 8687738322192148323)
  String? displayName;

  /// User's phone number
  @JsonKey(includeIfNull: false, name: 'phone_number')
  @Property(uid: 6470751833752511721)
  String? phoneNumber;

  /// URL to user's profile photo
  @JsonKey(includeIfNull: false, name: 'photo_url')
  @Property(uid: 5439725296789890440)
  String? photoUrl;

  /// Whether the user's email is verified
  @JsonKey(name: 'is_email_verified')
  @Property(uid: 378624735367121720)
  bool isEmailVerified;

  /// Whether the user account is active
  @JsonKey(name: 'is_active')
  @Property(uid: 4334511481040570339)
  bool isActive;

  /// Last time user data was updated
  @Property(type: PropertyType.date, uid: 2779906631762941843)
  @JsonKey(
    toJson: _dateToJson,
    fromJson: _dateFromJson,
  )
  DateTime updatedAt;

  /// When the user was created
  @Property(type: PropertyType.date, uid: 1334135131845324837)
  @JsonKey(
    toJson: _dateToJson,
    fromJson: _dateFromJson,
  )
  DateTime createdAt;

  // Constructor with named parameters
  UserModel({
    this.autoId = 0,
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.isEmailVerified = false,
    this.isActive = false,
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
      autoId: autoId,
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
