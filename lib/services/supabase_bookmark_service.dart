import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/article_model.dart';
import 'supabase_bootstrap.dart';

class SupabaseBookmarkService {
  SupabaseBookmarkService();

  static const String _table = 'user_bookmarks';

  SupabaseClient? get _client => SupabaseBootstrap.clientOrNull;

  bool get isReady => _client != null;

  User? get _currentUser => _client?.auth.currentUser;

  Future<List<ArticleModel>> fetchBookmarks() async {
    final client = _client;
    final user = _currentUser;
    if (client == null || user == null) {
      return const [];
    }

    final response = await client
        .from(_table)
        .select()
        .eq('user_id', user.id)
        .order('saved_at', ascending: false);

    return (response as List<dynamic>)
        .map((row) => ArticleModel.fromBookmarkPayload(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> upsertBookmark(ArticleModel article) async {
    final client = _client;
    final user = _currentUser;
    if (client == null || user == null || article.url == null) {
      return;
    }

    await client.from(_table).upsert(
      {
        'user_id': user.id,
        ...article.toBookmarkPayload(),
      },
      onConflict: 'user_id,article_url',
    );
  }

  Future<void> removeBookmark(String? articleUrl) async {
    final client = _client;
    final user = _currentUser;
    if (client == null || user == null || articleUrl == null) {
      return;
    }

    await client
        .from(_table)
        .delete()
        .eq('user_id', user.id)
        .eq('article_url', articleUrl);
  }

  Future<void> syncLocalBookmarks(List<ArticleModel> localBookmarks) async {
    final client = _client;
    final user = _currentUser;
    if (client == null || user == null || localBookmarks.isEmpty) {
      return;
    }

    final payload = localBookmarks
        .where((article) => article.url != null)
        .map(
          (article) => {
            'user_id': user.id,
            ...article.toBookmarkPayload(),
          },
        )
        .toList();

    if (payload.isEmpty) {
      return;
    }

    await client.from(_table).upsert(
      payload,
      onConflict: 'user_id,article_url',
    );
  }
}
