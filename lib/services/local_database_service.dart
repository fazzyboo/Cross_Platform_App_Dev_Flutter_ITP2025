import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:rest_api_call/models/news_item.dart';
import 'package:rest_api_call/database/database_factory_io.dart' if (dart.library.html) 'package:rest_api_call/database/database_factory_web.dart' as db_factory;

class LocalDatabaseService {
  static const String _dbName = 'hacker_news.db';
  static const String _storeName = 'news_items';

  late Database _database;
  final _newsItemStore = intMapStoreFactory.store(_storeName);
  final _storyIdStore = stringMapStoreFactory.store('story_ids'); // New store for story IDs

  Future<void> init() async {
    _database = await db_factory.getDatabase(_dbName);
  }

  Future<void> saveNewsItem(NewsItem item) async {
    await _newsItemStore.record(item.id).put(_database, item.toJson());
  }

  Future<NewsItem?> getNewsItem(int id) async {
    final recordSnapshot = await _newsItemStore.record(id).getSnapshot(_database);
    if (recordSnapshot != null) {
      return NewsItem.fromJson(recordSnapshot.value);
    }
    return null;
  }

  Future<void> saveStoryIds(String type, List<int> ids) async {
    await _storyIdStore.record(type).put(_database, {'ids': ids});
  }

  Future<List<int>?> getStoryIds(String type) async {
    final recordSnapshot = await _storyIdStore.record(type).getSnapshot(_database);
    if (recordSnapshot != null && recordSnapshot.value['ids'] is List) {
      return (recordSnapshot.value['ids'] as List).cast<int>();
    }
    return null;
  }
}
