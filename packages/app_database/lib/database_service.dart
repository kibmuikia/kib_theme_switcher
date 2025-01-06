import 'package:app_database/dao/export.dart';
import 'package:app_database/models/export.dart';
import 'package:app_database/objectbox.g.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:kib_debug_print/kib_debug_print.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
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

  late final Admin? _admin;

  /// Theme mode DAO
  late final ThemeModeDao themeModeDao;
  /// User DAO
  late final UserModelDao userModelDao;

  /// Initialize the database
  static Future<DatabaseService> create() async {
    final service = DatabaseService._create();
    final result =  await service._init();
    kprint.lg("database initialisation: $result", symbol: "💾");
    _instance = service;
    return service;
  }

  /// Initialize ObjectBox
  Future<bool> _init() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final dbDirectory = p.join(docsDir.path, "objectbox");

      _store = await openStore(directory: dbDirectory);

      if (kDebugMode && Admin.isAvailable()) {
        _admin = Admin(_store);
      }

      // Initialize DAOs
      themeModeDao = ThemeModeDao(_store.box<ThemeModeModel>());
      userModelDao = UserModelDao(_store.box<UserModel>());

      return true;
    } on Exception catch (e, trace) {
      kprint.err("$e,\n$trace");
      return false;
    }
  }

  /// Close the database
  void close() {
    try {
      themeModeDao.close();
      _admin?.close();
      _store.close();
    } on Exception catch (e) {
      debugPrint('** DatabaseService:close: $e *');
    }
  }
}
