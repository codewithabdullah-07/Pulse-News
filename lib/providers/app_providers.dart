import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article_model.dart';
import '../models/category_model.dart';
import '../services/bookmark_service.dart';
import '../services/news_service.dart';
import '../services/supabase_auth_service.dart';
import '../services/supabase_bookmark_service.dart';
import '../services/supabase_bootstrap.dart';

final newsServiceProvider = Provider<NewsService>((ref) => NewsService());

final bookmarkServiceProvider =
    Provider<BookmarkService>((ref) => BookmarkService());

final supabaseConfiguredProvider =
    Provider<bool>((ref) => SupabaseBootstrap.isConfigured);

final supabaseAuthServiceProvider =
    Provider<SupabaseAuthService>((ref) => SupabaseAuthService());

final supabaseBookmarkServiceProvider =
    Provider<SupabaseBookmarkService>((ref) => SupabaseBookmarkService());

class ThemeNotifier extends StateNotifier<bool> {
  static const _prefsKey = 'isDarkMode';

  ThemeNotifier(super.initialValue);

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, state);
  }

  static Future<bool> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier(false);
});

final selectedCategoryProvider =
    StateProvider<NewsCategory>((ref) => NewsCategory.topHeadlines);

final searchQueryProvider = StateProvider<String>((ref) => '');
final isSearchActiveProvider = StateProvider<bool>((ref) => false);

class NotificationsState {
  const NotificationsState({
    this.unreadArticles = const [],
    this.inboxArticles = const [],
    this.hasSeeded = false,
  });

  final List<ArticleModel> unreadArticles;
  final List<ArticleModel> inboxArticles;
  final bool hasSeeded;

  NotificationsState copyWith({
    List<ArticleModel>? unreadArticles,
    List<ArticleModel>? inboxArticles,
    bool? hasSeeded,
  }) {
    return NotificationsState(
      unreadArticles: unreadArticles ?? this.unreadArticles,
      inboxArticles: inboxArticles ?? this.inboxArticles,
      hasSeeded: hasSeeded ?? this.hasSeeded,
    );
  }
}

class NewsFeedState {
  final List<ArticleModel> articles;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;
  final int recycleCursor;

  const NewsFeedState({
    this.articles = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
    this.recycleCursor = 0,
  });

  NewsFeedState copyWith({
    List<ArticleModel>? articles,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    int? recycleCursor,
    bool clearError = false,
  }) {
    return NewsFeedState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      recycleCursor: recycleCursor ?? this.recycleCursor,
    );
  }
}

class NewsFeedNotifier extends StateNotifier<NewsFeedState> {
  NewsFeedNotifier(this._newsService, this._ref)
      : super(const NewsFeedState()) {
    _loadInitial();
  }

  final NewsService _newsService;
  final Ref _ref;

  void _loadInitial() {
    fetchNews();
  }

  Future<void> changeCategory(NewsCategory category) async {
    _ref.read(selectedCategoryProvider.notifier).state = category;
    state = const NewsFeedState(isLoading: true);
    await fetchNews(category: category);
  }

  Future<void> fetchNews({
    NewsCategory? category,
    bool silent = false,
  }) async {
    final NewsCategory cat = category ?? _ref.read(selectedCategoryProvider);
    if (silent) {
      state = state.copyWith(
        isLoading: false,
        clearError: true,
      );
    } else if (state.articles.isEmpty) {
      state = const NewsFeedState(isLoading: true);
    } else {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );
    }

    try {
      final batch = await _newsService.fetchByCategoryBatch(
        category: cat,
        page: 1,
      );
      state = NewsFeedState(
        articles: batch.articles,
        isLoading: false,
        currentPage: batch.nextPage,
        hasMore: batch.hasMore,
        recycleCursor: 0,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }

    final cat = _ref.read(selectedCategoryProvider);
    final requestPage = state.currentPage;

    state = state.copyWith(isLoadingMore: true);

    try {
      final batch = await _newsService.fetchByCategoryBatch(
        category: cat,
        page: requestPage,
      );
      final existingUrls = state.articles.map((article) => article.url).toSet();
      final uniqueMore = batch.articles
          .where((article) => !existingUrls.contains(article.url))
          .toList();

      if (uniqueMore.isEmpty && !batch.hasMore && state.articles.isNotEmpty) {
        final recycled = _buildRecycleChunk(
          source: state.articles,
          startIndex: state.recycleCursor,
        );

        state = state.copyWith(
          articles: [...state.articles, ...recycled],
          isLoadingMore: false,
          currentPage: 1,
          hasMore: true,
          recycleCursor:
              (state.recycleCursor + recycled.length) % state.articles.length,
        );
        return;
      }

      state = state.copyWith(
        articles: [...state.articles, ...uniqueMore],
        isLoadingMore: false,
        currentPage: batch.nextPage,
        hasMore: batch.hasMore || batch.articles.isNotEmpty,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  List<ArticleModel> _buildRecycleChunk({
    required List<ArticleModel> source,
    required int startIndex,
  }) {
    if (source.isEmpty) {
      return const [];
    }

    final chunkSize = source.length >= 20 ? 20 : source.length;
    return List<ArticleModel>.generate(
      chunkSize,
      (index) => source[(startIndex + index) % source.length],
    );
  }
}

final newsFeedProvider =
    StateNotifierProvider<NewsFeedNotifier, NewsFeedState>((ref) {
  final service = ref.watch(newsServiceProvider);
  return NewsFeedNotifier(service, ref);
});

class SearchState {
  final List<ArticleModel> results;
  final bool isSearching;
  final String? errorMessage;

  const SearchState({
    this.results = const [],
    this.isSearching = false,
    this.errorMessage,
  });

  SearchState copyWith({
    List<ArticleModel>? results,
    bool? isSearching,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SearchState(
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier(this._service) : super(const SearchState());

  final NewsService _service;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(isSearching: true, clearError: true);

    try {
      final results = await _service.searchArticles(query: query);
      state = state.copyWith(results: results, isSearching: false);
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clear() => state = const SearchState();
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref.watch(newsServiceProvider));
});

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  NotificationsNotifier(this._service) : super(const NotificationsState());

  final NewsService _service;
  final Set<String> _knownUrls = <String>{};
  final Set<String> _dismissedUrls = <String>{};
  bool _isRefreshing = false;

  Future<List<ArticleModel>> refresh() async {
    if (_isRefreshing) {
      return const [];
    }

    _isRefreshing = true;
    try {
      final latestArticles = (await _service.fetchNotificationArticles())
          .where((article) => !_dismissedUrls.contains(article.url))
          .toList();
      final latestUrls = latestArticles
          .map((article) => article.url)
          .whereType<String>()
          .toSet();

      if (!state.hasSeeded) {
        _knownUrls.addAll(latestUrls);
        state = state.copyWith(
          unreadArticles: latestArticles,
          inboxArticles: latestArticles,
          hasSeeded: true,
        );
        return latestArticles;
      }

      final newArticles = latestArticles
          .where((article) => !_knownUrls.contains(article.url))
          .toList();

      _knownUrls.addAll(latestUrls);

      state = state.copyWith(
        unreadArticles: newArticles.isEmpty
            ? state.unreadArticles
            : _mergeArticles(newArticles, state.unreadArticles),
        inboxArticles: _mergeArticles(latestArticles, state.inboxArticles),
      );
      return newArticles;
    } finally {
      _isRefreshing = false;
    }
  }

  List<ArticleModel> openInbox() {
    final snapshot = state.unreadArticles.isNotEmpty
        ? state.unreadArticles
        : state.inboxArticles;
    state = state.copyWith(unreadArticles: const []);
    return snapshot;
  }

  void dismissArticle(String? url) {
    if (url == null) {
      return;
    }

    _dismissedUrls.add(url);
    state = state.copyWith(
      unreadArticles:
          state.unreadArticles.where((article) => article.url != url).toList(),
      inboxArticles:
          state.inboxArticles.where((article) => article.url != url).toList(),
    );
  }

  void clearAll() {
    _dismissedUrls.addAll(
      state.inboxArticles.map((article) => article.url).whereType<String>(),
    );
    state = state.copyWith(
      unreadArticles: const [],
      inboxArticles: const [],
    );
  }

  void clearVisible() {
    state = state.copyWith(
      unreadArticles: const [],
      inboxArticles: const [],
    );
  }

  List<ArticleModel> _mergeArticles(
    List<ArticleModel> primary,
    List<ArticleModel> secondary,
  ) {
    final seen = <String>{};
    final merged = <ArticleModel>[];

    for (final article in [...primary, ...secondary]) {
      final url = article.url;
      if (url == null || seen.contains(url)) {
        continue;
      }
      seen.add(url);
      merged.add(article);
      if (merged.length >= 20) {
        break;
      }
    }

    return merged;
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(ref.watch(newsServiceProvider));
});

class BookmarkNotifier extends StateNotifier<List<ArticleModel>> {
  BookmarkNotifier(this._service, this._supabaseService) : super([]) {
    _load();
  }

  final BookmarkService _service;
  final SupabaseBookmarkService _supabaseService;

  void _load() {
    state = _service.getAllBookmarks();
  }

  Future<void> syncFromRemote() async {
    if (!_supabaseService.isReady) {
      return;
    }

    final remoteBookmarks = await _supabaseService.fetchBookmarks();
    if (remoteBookmarks.isEmpty) {
      return;
    }

    for (final article in remoteBookmarks) {
      if (!_service.isBookmarked(article.url)) {
        await _service.saveArticle(article);
      }
    }
    state = _service.getAllBookmarks();
  }

  Future<void> syncLocalToRemote() async {
    await _supabaseService.syncLocalBookmarks(state);
  }

  Future<void> toggle(ArticleModel article) async {
    final wasBookmarked = _service.isBookmarked(article.url);
    await _service.toggleBookmark(article);
    if (wasBookmarked) {
      await _supabaseService.removeBookmark(article.url);
    } else {
      await _supabaseService.upsertBookmark(article);
    }
    state = _service.getAllBookmarks();
  }

  bool isBookmarked(String? url) => _service.isBookmarked(url);

  Future<void> clearAll() async {
    final bookmarks = state;
    await _service.clearAll();
    for (final article in bookmarks) {
      await _supabaseService.removeBookmark(article.url);
    }
    state = [];
  }
}

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, List<ArticleModel>>((ref) {
  return BookmarkNotifier(
    ref.watch(bookmarkServiceProvider),
    ref.watch(supabaseBookmarkServiceProvider),
  );
});
