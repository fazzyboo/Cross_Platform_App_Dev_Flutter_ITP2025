import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

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
    return await databaseFactoryWeb.openDatabase('notes.db');
  }
}
