import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rest_api_call/models/news_item.dart';
import 'package:rest_api_call/services/local_database_service.dart';

part 'news_provider.g.dart';

@riverpod
LocalDatabaseService localDatabaseService(LocalDatabaseServiceRef ref) {
  return LocalDatabaseService();
}

@riverpod
NewsProvider newsProvider(NewsProviderRef ref) {
  final localDbService = ref.watch(localDatabaseServiceProvider);
  return NewsProvider(localDbService);
}

@riverpod
Future<List<NewsItem>> topStories(TopStoriesRef ref) async {
  final newsService = ref.watch(newsProviderProvider);
  final topStoryIds = await newsService.fetchStoryIds('topstories');
  final top10StoryIds = topStoryIds.take(10).toList();
  final List<NewsItem> stories = [];
  for (int id in top10StoryIds) {
    stories.add(await newsService.fetchItem(id));
  }
  return stories;
}

@riverpod
Future<List<NewsItem>> bestStories(BestStoriesRef ref) async {
  final newsService = ref.watch(newsProviderProvider);
  final bestStoryIds = await newsService.fetchStoryIds('beststories');
  final best10StoryIds = bestStoryIds.take(10).toList();
  final List<NewsItem> stories = [];
  for (int id in best10StoryIds) {
    stories.add(await newsService.fetchItem(id));
  }
  return stories;
}

@riverpod
Future<List<NewsItem>> newStories(NewStoriesRef ref) async {
  final newsService = ref.watch(newsProviderProvider);
  final newStoryIds = await newsService.fetchStoryIds('newstories');
  final new10StoryIds = newStoryIds.take(10).toList();
  final List<NewsItem> stories = [];
  for (int id in new10StoryIds) {
    stories.add(await newsService.fetchItem(id));
  }
  return stories;
}

@riverpod
Future<NewsItem> newsItemDetails(NewsItemDetailsRef ref, int itemId) async {
  final newsService = ref.watch(newsProviderProvider);
  return await newsService.fetchItem(itemId);
}

@riverpod
Future<List<NewsItem>> storyComments(StoryCommentsRef ref, List<int> commentIds) async {
  final newsService = ref.watch(newsProviderProvider);
  final List<NewsItem> comments = [];
  for (int id in commentIds) {
    comments.add(await newsService.fetchItem(id));
  }
  return comments;
}

class NewsProvider {
  static const String _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  final Dio _dio = Dio();
  final LocalDatabaseService _localDbService;

  NewsProvider(this._localDbService);

  Future<List<int>> fetchStoryIds(String type) async {
    // Try to get from cache first
    final cachedIds = await _localDbService.getStoryIds(type);
    if (cachedIds != null) {
      if (kDebugMode) {
        print('Fetched $type story IDs from cache.');
      }
      return cachedIds;
    }

    // If not in cache, fetch from API
    try {
      final response = await _dio.get('$_baseUrl/$type.json');
      if (response.statusCode == 200) {
        final List<dynamic> ids = response.data;
        final List<int> intIds = ids.cast<int>();
        // Save to cache
        await _localDbService.saveStoryIds(type, intIds);
        if (kDebugMode) {
          print('Fetched $type story IDs from API and saved to cache.');
        }
        return intIds;
      } else {
        throw Exception('Failed to load $type story IDs: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching $type story IDs from API: $e');
      }
      throw Exception('Failed to load $type story IDs');
    }
  }

  Future<NewsItem> fetchItem(int id) async {
    // Try to get from cache first
    final cachedItem = await _localDbService.getNewsItem(id);
    if (cachedItem != null) {
      if (kDebugMode) {
        print('Fetched item $id from cache.');
      }
      return cachedItem;
    }

    // If not in cache, fetch from API
    try {
      final response = await _dio.get('$_baseUrl/item/$id.json');
      if (response.statusCode == 200) {
        final NewsItem item = NewsItem.fromJson(response.data);
        // Save to cache
        await _localDbService.saveNewsItem(item);
        if (kDebugMode) {
          print('Fetched item $id from API and saved to cache.');
        }
        return item;
      } else {
        throw Exception('Failed to load item $id: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching item $id from API: $e');
      }
      throw Exception('Failed to load item $id');
    }
  }
}
