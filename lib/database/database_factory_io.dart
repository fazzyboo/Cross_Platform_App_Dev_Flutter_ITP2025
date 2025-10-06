import 'package:sembast/sembast.dart';
import 'package:sembast_io/sembast_io.dart'; // Corrected import
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<Database> getDatabase(String dbName) async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final dbPath = join(appDocumentDir.path, dbName);
  return await databaseFactoryIo.openDatabase(dbPath);
}
