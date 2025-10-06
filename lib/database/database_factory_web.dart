import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

Future<Database> getDatabase(String dbName) async {
  return await databaseFactoryWeb.openDatabase(dbName);
}
