// MODIFIED BY CODEX — UI UPGRADE
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations_ext.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/news_card.dart';
import '../widgets/pulse_app_bar.dart';
import 'article_detail_screen.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: PulseAppBar(
        title: l10n.savedTitle,
        subtitle: l10n.savedArticlesCount(bookmarks.length),
      ),
      body: SafeArea(
        top: false,
        child: bookmarks.isEmpty
            ? _EmptyBookmarks()
            : Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(18, 12, 18, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.savedArticlesCount(bookmarks.length),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _confirmClearAll(context, ref),
                          child: Text(l10n.clearAll),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 28),
                      itemCount: bookmarks.length,
                      itemBuilder: (context, index) {
                        final article = bookmarks[index];
                        return Dismissible(
                          key: Key(article.url ?? '$index'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                18, 8, 18, 8),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            alignment: AlignmentDirectional.centerEnd,
                            padding: const EdgeInsetsDirectional.only(end: 24),
                            child: Text(
                              l10n.remove,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          onDismissed: (_) => ref
                              .read(bookmarkProvider.notifier)
                              .toggle(article),
                          child: NewsCard(
                            article: article,
                            layout: NewsCardLayout.compact,
                            index: index,
                            heroTag: 'bookmark_${article.url ?? index}',
                            onTap: () => Navigator.of(context).push(
                              _slideRoute(
                                ArticleDetailScreen(
                                  article: article,
                                  heroTag: 'bookmark_${article.url ?? index}',
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

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.clearSavedTitle),
        content: Text(l10n.clearSavedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(bookmarkProvider.notifier).clearAll();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );
  }
}

class _EmptyBookmarks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: AppColors.violet.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_outline_rounded,
                size: 42,
                color: AppColors.violet,
              ),
            ).animate().scale(duration: 420.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 20),
            Text(
              l10n.savedEmptyTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.savedEmptyMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

PageRoute _slideRoute(Widget page) {
  return PageRouteBuilder(
    settings: RouteSettings(name: page.runtimeType.toString()),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}
