// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localDatabaseServiceHash() =>
    r'af2e2d1920bd32eac995e8440041446fc5a66fd8';

/// See also [localDatabaseService].
@ProviderFor(localDatabaseService)
final localDatabaseServiceProvider =
    AutoDisposeProvider<LocalDatabaseService>.internal(
  localDatabaseService,
  name: r'localDatabaseServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localDatabaseServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalDatabaseServiceRef = AutoDisposeProviderRef<LocalDatabaseService>;
String _$newsProviderHash() => r'2a770c4060cfbac75477f4e87094ddecd4e44e96';

/// See also [newsProvider].
@ProviderFor(newsProvider)
final newsProviderProvider = AutoDisposeProvider<NewsProvider>.internal(
  newsProvider,
  name: r'newsProviderProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$newsProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewsProviderRef = AutoDisposeProviderRef<NewsProvider>;
String _$topStoriesHash() => r'b2ed2a8ce2c0e86a6932b8c09bc784881d240eaf';

/// See also [topStories].
@ProviderFor(topStories)
final topStoriesProvider = AutoDisposeFutureProvider<List<NewsItem>>.internal(
  topStories,
  name: r'topStoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$topStoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TopStoriesRef = AutoDisposeFutureProviderRef<List<NewsItem>>;
String _$bestStoriesHash() => r'8bf3c0087f2025812d1d0c68d30e7b8ca52e7236';

/// See also [bestStories].
@ProviderFor(bestStories)
final bestStoriesProvider = AutoDisposeFutureProvider<List<NewsItem>>.internal(
  bestStories,
  name: r'bestStoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bestStoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BestStoriesRef = AutoDisposeFutureProviderRef<List<NewsItem>>;
String _$newStoriesHash() => r'f8c974de44ca787b46da26aba48473afd7b9b0dc';

/// See also [newStories].
@ProviderFor(newStories)
final newStoriesProvider = AutoDisposeFutureProvider<List<NewsItem>>.internal(
  newStories,
  name: r'newStoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$newStoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewStoriesRef = AutoDisposeFutureProviderRef<List<NewsItem>>;
String _$newsItemDetailsHash() => r'3101d84d9f421daf0dd87f39cb606d5096708f8d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [newsItemDetails].
@ProviderFor(newsItemDetails)
const newsItemDetailsProvider = NewsItemDetailsFamily();

/// See also [newsItemDetails].
class NewsItemDetailsFamily extends Family<AsyncValue<NewsItem>> {
  /// See also [newsItemDetails].
  const NewsItemDetailsFamily();

  /// See also [newsItemDetails].
  NewsItemDetailsProvider call(
    int itemId,
  ) {
    return NewsItemDetailsProvider(
      itemId,
    );
  }

  @override
  NewsItemDetailsProvider getProviderOverride(
    covariant NewsItemDetailsProvider provider,
  ) {
    return call(
      provider.itemId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'newsItemDetailsProvider';
}

/// See also [newsItemDetails].
class NewsItemDetailsProvider extends AutoDisposeFutureProvider<NewsItem> {
  /// See also [newsItemDetails].
  NewsItemDetailsProvider(
    int itemId,
  ) : this._internal(
          (ref) => newsItemDetails(
            ref as NewsItemDetailsRef,
            itemId,
          ),
          from: newsItemDetailsProvider,
          name: r'newsItemDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$newsItemDetailsHash,
          dependencies: NewsItemDetailsFamily._dependencies,
          allTransitiveDependencies:
              NewsItemDetailsFamily._allTransitiveDependencies,
          itemId: itemId,
        );

  NewsItemDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final int itemId;

  @override
  Override overrideWith(
    FutureOr<NewsItem> Function(NewsItemDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NewsItemDetailsProvider._internal(
        (ref) => create(ref as NewsItemDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<NewsItem> createElement() {
    return _NewsItemDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewsItemDetailsProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NewsItemDetailsRef on AutoDisposeFutureProviderRef<NewsItem> {
  /// The parameter `itemId` of this provider.
  int get itemId;
}

class _NewsItemDetailsProviderElement
    extends AutoDisposeFutureProviderElement<NewsItem> with NewsItemDetailsRef {
  _NewsItemDetailsProviderElement(super.provider);

  @override
  int get itemId => (origin as NewsItemDetailsProvider).itemId;
}

String _$storyCommentsHash() => r'6036fe84eeebc2164f3e23c417046507f451551b';

/// See also [storyComments].
@ProviderFor(storyComments)
const storyCommentsProvider = StoryCommentsFamily();

/// See also [storyComments].
class StoryCommentsFamily extends Family<AsyncValue<List<NewsItem>>> {
  /// See also [storyComments].
  const StoryCommentsFamily();

  /// See also [storyComments].
  StoryCommentsProvider call(
    List<int> commentIds,
  ) {
    return StoryCommentsProvider(
      commentIds,
    );
  }

  @override
  StoryCommentsProvider getProviderOverride(
    covariant StoryCommentsProvider provider,
  ) {
    return call(
      provider.commentIds,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storyCommentsProvider';
}

/// See also [storyComments].
class StoryCommentsProvider extends AutoDisposeFutureProvider<List<NewsItem>> {
  /// See also [storyComments].
  StoryCommentsProvider(
    List<int> commentIds,
  ) : this._internal(
          (ref) => storyComments(
            ref as StoryCommentsRef,
            commentIds,
          ),
          from: storyCommentsProvider,
          name: r'storyCommentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyCommentsHash,
          dependencies: StoryCommentsFamily._dependencies,
          allTransitiveDependencies:
              StoryCommentsFamily._allTransitiveDependencies,
          commentIds: commentIds,
        );

  StoryCommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.commentIds,
  }) : super.internal();

  final List<int> commentIds;

  @override
  Override overrideWith(
    FutureOr<List<NewsItem>> Function(StoryCommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryCommentsProvider._internal(
        (ref) => create(ref as StoryCommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        commentIds: commentIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<NewsItem>> createElement() {
    return _StoryCommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryCommentsProvider && other.commentIds == commentIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, commentIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StoryCommentsRef on AutoDisposeFutureProviderRef<List<NewsItem>> {
  /// The parameter `commentIds` of this provider.
  List<int> get commentIds;
}

class _StoryCommentsProviderElement
    extends AutoDisposeFutureProviderElement<List<NewsItem>>
    with StoryCommentsRef {
  _StoryCommentsProviderElement(super.provider);

  @override
  List<int> get commentIds => (origin as StoryCommentsProvider).commentIds;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
