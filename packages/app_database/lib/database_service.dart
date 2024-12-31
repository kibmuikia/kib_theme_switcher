import 'package:app_database/dao/export.dart';
import 'package:app_database/models/export.dart';
import 'package:app_database/objectbox.g.dart';
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

  /// Theme mode DAO
  late final ThemeModeDao themeModeDao;

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

    // Initialize DAOs
    themeModeDao = ThemeModeDao(_store.box<ThemeModeModel>());
  }

  /// Close the database
  void close() {
    themeModeDao.close();
    _store.close();
  }
}
