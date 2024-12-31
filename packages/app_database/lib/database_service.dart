
import 'package:app_database/models/export.dart';
import 'package:app_database/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service class to handle all database operations
class DatabaseService {
  /// Private constructor
  DatabaseService._create();

  /// Singleton instance
  static DatabaseService? _instance;

  /// Get the singleton instance of DatabaseService
  static DatabaseService get instance => _instance ?? DatabaseService._create();

  /// The ObjectBox Store, created in init()
  late final Store _store;

  /// Box for ThemeModeModel
  late final Box<ThemeModeModel> _themeModeBox;

  /// Initialize the database
  static Future<DatabaseService> create() async {
    final service = DatabaseService._create();
    await service._init();
    _instance = service;
    return service;
  }

  /// Initialize ObjectBox
  Future<void> _init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbDirectory = p.join(docsDir.path, "objectbox");

    _store = await openStore(directory: dbDirectory);
    // set boxes
    _themeModeBox = _store.box<ThemeModeModel>();
  }

  /// Close the database
  void close() {
    _store.close();
  }

  /// Get the current theme mode
  Future<ThemeModeModel?> getCurrentThemeMode() async {
    final query = _themeModeBox.query()
      ..order(ThemeModeModel_.createdAt, flags: Order.descending);
    return query.build().findFirst();
  }

  /// Save a new theme mode
  Future<int> saveThemeMode(String mode) async {
    final themeMode = ThemeModeModel(mode: mode);
    return _themeModeBox.put(themeMode);
  }

  //
}
