import 'package:sembast/sembast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';

class DatabaseService {
  // Singleton instance
  static final DatabaseService _singleton = DatabaseService._internal();

  // A private constructor. Allows us to create a singleton instance
  DatabaseService._internal();

  // Singleton accessor
  static DatabaseService get instance => _singleton;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'notes.db');
    return await databaseFactoryIo.openDatabase(dbPath);
  }
}
