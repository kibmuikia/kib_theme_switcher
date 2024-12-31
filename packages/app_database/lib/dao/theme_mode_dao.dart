import 'package:app_database/objectbox.g.dart';
import 'package:app_database/models/export.dart' show ThemeModeModel;
import 'base.dart';

/// DAO for handling theme mode persistence
class ThemeModeDao extends BaseDao<ThemeModeModel> {
  /// Constructor
  ThemeModeDao(this._box);

  final Box<ThemeModeModel> _box;

  @override
  Box<ThemeModeModel> get box => _box;

  /// Get the current theme mode
  ThemeModeModel? getCurrentThemeMode() {
    try {
      final query = box.query()
        ..order(ThemeModeModel_.createdAt, flags: Order.descending);
      return query.build().findFirst();
    } on Exception catch (e) {
      return null;
    }
  }

  /// Save a new theme mode
  int saveThemeMode(String mode) {
    final themeMode = ThemeModeModel(mode: mode);
    return put(themeMode);
  }
}

