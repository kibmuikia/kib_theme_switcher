import 'package:objectbox/objectbox.dart';

@Entity()
class ThemeModeModel {
  @Id()
  int id;

  /// The theme mode: 'light', 'dark', or 'system'
  String mode;

  /// When this theme mode was set
  @Property(type: PropertyType.date)
  DateTime createdAt;

  ThemeModeModel({
    this.id = 0,
    required this.mode,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() => 'ThemeModeModel(id: $id, mode: $mode, createdAt: $createdAt)';
}
