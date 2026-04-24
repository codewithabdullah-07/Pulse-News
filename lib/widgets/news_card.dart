// MODIFIED BY CODEX — UI UPGRADE
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/article_model.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

enum NewsCardLayout { featured, compact, minimal }

class NewsCard extends ConsumerWidget {
  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
    this.layout = NewsCardLayout.compact,
    this.index = 0,
    this.categoryLabel,
    this.heroTag,
  });

  final ArticleModel article;
  final NewsCardLayout layout;
  final VoidCallback onTap;
  final int index;
  final String? categoryLabel;
  final String? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBookmarked = ref.watch(
      bookmarkProvider.select(
        (bookmarks) => bookmarks.any((saved) => saved.url == article.url),
      ),
    );
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    final child = GestureDetector(
      onTap: onTap,
      child: switch (layout) {
        NewsCardLayout.featured => _FeaturedCard(
            article: article,
            isDark: isDark,
            isBookmarked: isBookmarked,
            categoryLabel: categoryLabel,
            heroTag: heroTag,
            onBookmark: () async {
              await ref.read(bookmarkProvider.notifier).toggle(article);
            },
          ),
        NewsCardLayout.compact => _CompactCard(
            article: article,
            isDark: isDark,
            isBookmarked: isBookmarked,
            categoryLabel: categoryLabel,
            heroTag: heroTag,
            onBookmark: () async {
              await ref.read(bookmarkProvider.notifier).toggle(article);
            },
          ),
        NewsCardLayout.minimal => _MinimalCard(
            article: article,
            isDark: isDark,
            categoryLabel: categoryLabel,
          ),
      },
    );

    if (disableAnimations) {
      return child;
    }

    return child
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 320.ms, curve: Curves.easeOutCubic)
        .slideY(
            begin: 0.08, end: 0, duration: 320.ms, curve: Curves.easeOutCubic);
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.article,
    required this.isDark,
    required this.isBookmarked,
    required this.onBookmark,
    this.categoryLabel,
    this.heroTag,
  });

  final ArticleModel article;
  final bool isDark;
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final String? categoryLabel;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(18, 10, 18, 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: heroTag ?? article.url ?? article.title ?? hashCode.toString(),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              child: Stack(
                children: [
                  _CardImage(
                    article: article,
                    isDark: isDark,
                    height: 240,
                    width: double.infinity,
                  ),
                  if (categoryLabel != null)
                    PositionedDirectional(
                      start: 16,
                      top: 16,
                      child: _Badge(label: categoryLabel!),
                    ),
                  PositionedDirectional(
                    end: 16,
                    bottom: 16,
                    child: _BookmarkButton(
                      isBookmarked: isBookmarked,
                      onTap: onBookmark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  article.description ?? article.cleanContent,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        article.source?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.secondaryAccent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _TimeLabel(
                      publishedAt: article.publishedAt,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactCard extends StatelessWidget {
  const _CompactCard({
    required this.article,
    required this.isDark,
    required this.isBookmarked,
    required this.onBookmark,
    this.categoryLabel,
    this.heroTag,
  });

  final ArticleModel article;
  final bool isDark;
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final String? categoryLabel;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(18, 8, 18, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.32),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: heroTag ??
                    article.url ??
                    article.title ??
                    hashCode.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _CardImage(
                    article: article,
                    isDark: isDark,
                    height: 96,
                    width: 96,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (categoryLabel != null)
                                _Badge(
                                  label: categoryLabel!,
                                  compact: true,
                                ),
                              Text(
                                article.source?.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _BookmarkButton(
                          isBookmarked: isBookmarked,
                          onTap: onBookmark,
                          compact: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          theme.textTheme.titleMedium?.copyWith(height: 1.25),
                    ),
                    const SizedBox(height: 10),
                    _TimeLabel(
                      publishedAt: article.publishedAt,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.16),
          ),
        ],
      ),
    );
  }
}

class _MinimalCard extends StatelessWidget {
  const _MinimalCard({
    required this.article,
    required this.isDark,
    this.categoryLabel,
  });

  final ArticleModel article;
  final bool isDark;
  final String? categoryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(18, 6, 18, 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (categoryLabel != null)
            _Badge(label: categoryLabel!, compact: true),
          if (categoryLabel != null) const SizedBox(height: 8),
          Text(
            article.title ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            article.source?.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    this.compact = false,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryAccent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.secondaryAccent,
              fontSize: compact ? 10 : 11,
            ),
      ),
    );
  }
}

class _TimeLabel extends StatelessWidget {
  const _TimeLabel({
    this.publishedAt,
    required this.isDark,
  });

  final String? publishedAt;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (publishedAt == null) {
      return const SizedBox.shrink();
    }
    try {
      final date = DateTime.parse(publishedAt!);
      return Text(
        timeago.format(date),
        style: Theme.of(context).textTheme.bodySmall,
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }
}

class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({
    required this.isBookmarked,
    required this.onTap,
    this.compact = false,
  });

  final bool isBookmarked;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
          child: Container(
            key: ValueKey(isBookmarked),
            padding: EdgeInsets.all(compact ? 6 : 8),
            decoration: BoxDecoration(
              color: isBookmarked
                  ? AppColors.violet.withValues(alpha: 0.18)
                  : theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.76),
              shape: BoxShape.circle,
              border: Border.all(
                color: isBookmarked
                    ? AppColors.violet.withValues(alpha: 0.35)
                    : Colors.transparent,
              ),
            ),
            child: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              size: compact ? 18 : 20,
              color: isBookmarked
                  ? AppColors.violet
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.article,
    required this.isDark,
    required this.height,
    required this.width,
  });

  final ArticleModel article;
  final bool isDark;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (!article.hasImage) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.secondaryAccent.withValues(alpha: 0.9),
              AppColors.violet.withValues(alpha: 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white,
          size: 32,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: article.urlToImage!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        width: width,
        height: height,
        color: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      ),
      errorWidget: (_, __, ___) => Container(
        width: width,
        height: height,
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        child:
            const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      ),
    );
  }
}
