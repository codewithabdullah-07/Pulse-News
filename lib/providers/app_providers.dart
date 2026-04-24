import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article_model.dart';
import '../models/category_model.dart';
import '../services/bookmark_service.dart';
import '../services/news_service.dart';

final newsServiceProvider = Provider<NewsService>((ref) => NewsService());

final bookmarkServiceProvider =
    Provider<BookmarkService>((ref) => BookmarkService());

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

  const NewsFeedState({
    this.articles = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
  });

  NewsFeedState copyWith({
    List<ArticleModel>? articles,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    bool clearError = false,
  }) {
    return NewsFeedState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
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

  Future<void> fetchNews({
    NewsCategory? category,
    bool silent = false,
  }) async {
    final NewsCategory cat = category ?? _ref.read(selectedCategoryProvider);
    state = state.copyWith(
      isLoading: !silent,
      clearError: true,
    );

    try {
      final articles = await _newsService.fetchByCategory(
        category: cat,
        page: 1,
      );
      state = NewsFeedState(
        articles: articles,
        isLoading: false,
        currentPage: 1,
        hasMore: articles.length >= 20,
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
    final nextPage = state.currentPage + 1;

    state = state.copyWith(isLoadingMore: true);

    try {
      final more = await _newsService.fetchByCategory(
        category: cat,
        page: nextPage,
      );
      state = state.copyWith(
        articles: [...state.articles, ...more],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: more.length >= 20,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

final newsFeedProvider =
    StateNotifierProvider<NewsFeedNotifier, NewsFeedState>((ref) {
  final service = ref.watch(newsServiceProvider);
  return NewsFeedNotifier(service, ref);
});

final categoryWatcherProvider = Provider<void>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  Future.microtask(() {
    ref.read(newsFeedProvider.notifier).fetchNews(category: category);
  });
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

  Future<void> refresh() async {
    if (_isRefreshing) {
      return;
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
        return;
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
  BookmarkNotifier(this._service) : super([]) {
    _load();
  }

  final BookmarkService _service;

  void _load() {
    state = _service.getAllBookmarks();
  }

  Future<void> toggle(ArticleModel article) async {
    await _service.toggleBookmark(article);
    state = _service.getAllBookmarks();
  }

  bool isBookmarked(String? url) => _service.isBookmarked(url);

  Future<void> clearAll() async {
    await _service.clearAll();
    state = [];
  }
}

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, List<ArticleModel>>((ref) {
  return BookmarkNotifier(ref.watch(bookmarkServiceProvider));
});
