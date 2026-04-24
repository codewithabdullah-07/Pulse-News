import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations_ext.dart';
import '../models/article_model.dart';
import '../providers/app_providers.dart';
import '../widgets/news_card.dart';
import '../widgets/pulse_app_bar.dart';
import 'article_detail_screen.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({
    super.key,
    required this.articles,
  });

  final List<ArticleModel> articles;

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  late List<ArticleModel> _articles;

  @override
  void initState() {
    super.initState();
    _articles = List<ArticleModel>.from(widget.articles);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: PulseAppBar(
        title: l10n.notifications,
        subtitle: _articles.isEmpty
            ? 'No new updates right now'
            : '${_articles.length} new updates',
        showBackButton: true,
        showThemeToggle: false,
        showNotification: false,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (_articles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.82),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.22),
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        ref.read(notificationsProvider.notifier).clearAll();
                        setState(() {
                          _articles = [];
                        });
                      },
                      icon: const Icon(Icons.done_all_rounded, size: 18),
                      label: const Text('Clear all'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: _articles.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No unread news yet. New articles will appear here automatically.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      itemCount: _articles.length,
                      itemBuilder: (context, index) {
                        final article = _articles[index];
                        return Dismissible(
                          key: Key(article.url ?? 'notification_$index'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                18, 8, 18, 8),
                            padding: const EdgeInsetsDirectional.only(end: 24),
                            alignment: AlignmentDirectional.centerEnd,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) {
                            ref
                                .read(notificationsProvider.notifier)
                                .dismissArticle(article.url);
                            setState(() {
                              _articles.removeAt(index);
                            });
                          },
                          child: NewsCard(
                            article: article,
                            layout: NewsCardLayout.compact,
                            index: index,
                            heroTag: 'notification_${article.url ?? index}',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                settings: RouteSettings(
                                  name: 'notification_${article.url ?? index}',
                                ),
                                builder: (_) => ArticleDetailScreen(
                                  article: article,
                                  heroTag:
                                      'notification_${article.url ?? index}',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
