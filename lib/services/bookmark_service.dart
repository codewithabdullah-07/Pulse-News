import 'package:hive_flutter/hive_flutter.dart';

import '../models/article_model.dart';

class BookmarkService {
  static const String _boxName = 'bookmarks';

  Box<ArticleModel> get _safeBox {
    if (!Hive.isBoxOpen(_boxName)) {
      throw StateError('Bookmarks box is not open.');
    }
    return Hive.box<ArticleModel>(_boxName);
  }

  Future<void> saveArticle(ArticleModel article) async {
    final key = _keyFromUrl(article.url);
    await _safeBox.put(key, article);
  }

  Future<void> removeArticle(String url) async {
    final key = _keyFromUrl(url);
    await _safeBox.delete(key);
  }

  Future<bool> toggleBookmark(ArticleModel article) async {
    if (isBookmarked(article.url)) {
      await removeArticle(article.url!);
      return false;
    }

    await saveArticle(article);
    return true;
  }

  bool isBookmarked(String? url) {
    if (url == null) {
      return false;
    }
    return _safeBox.containsKey(_keyFromUrl(url));
  }

  List<ArticleModel> getAllBookmarks() {
    return _safeBox.values.toList().reversed.toList();
  }

  Future<void> clearAll() async {
    await _safeBox.clear();
  }

  String _keyFromUrl(String? url) {
    if (url == null) {
      return DateTime.now().toIso8601String();
    }
    return url.hashCode.toString();
  }
}
