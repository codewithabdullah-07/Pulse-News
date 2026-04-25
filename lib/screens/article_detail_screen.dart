// MODIFIED BY CODEX — UI UPGRADE (FIXED VERSION)

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations_ext.dart';
import '../models/article_model.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class ArticleDetailScreen extends ConsumerStatefulWidget {
  const ArticleDetailScreen({
    super.key,
    required this.article,
    this.heroTag,
  });

  final ArticleModel article;
  final String? heroTag;

  @override
  ConsumerState<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  double _fontSizeDelta = 0;

  bool get isRtl => Directionality.of(context) == TextDirection.rtl;

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isBookmarked =
        ref.watch(bookmarkProvider.notifier).isBookmarked(article.url);

    final l10n = context.l10n;

    final author = (article.author?.trim().isNotEmpty ?? false)
        ? article.author!.trim()
        : l10n.articleUnknownAuthor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: article.hasImage ? 360 : 180,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.heroTag ??
                        article.url ??
                        article.title ??
                        hashCode.toString(),
                    child: article.hasImage
                        ? CachedNetworkImage(
                            imageUrl: article.urlToImage!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.violet,
                                  AppColors.secondaryAccent
                                ],
                              ),
                            ),
                          ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.18),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: MediaQuery.of(context).padding.top + 12,
                    start: 16,
                    end: 16,
                    child: Row(
                      children: [
                        _CircleAction(
                          icon: isRtl
                              ? Icons.arrow_forward_rounded
                              : Icons.arrow_back_rounded,
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                        const Spacer(),
                        _CircleAction(
                          icon: Icons.share_rounded,
                          onTap: () => _showShareOptions(article),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -26),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 54,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    Text(
                      article.title ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 28),
                    ).animate().fadeIn(duration: 320.ms),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              AppColors.secondaryAccent.withValues(alpha: 0.16),
                          child: Text(
                            author.characters.first.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.secondaryAccent,
                                ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.articleBy(author),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _metaLine(context, article),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _FontSlider(
                      value: _fontSizeDelta,
                      onChanged: (value) =>
                          setState(() => _fontSizeDelta = value),
                    ),
                    const SizedBox(height: 22),
                    if ((article.description?.isNotEmpty ?? false))
                      Text(
                        article.description!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 17 + _fontSizeDelta,
                            ),
                      ),
                    if ((article.description?.isNotEmpty ?? false))
                      const SizedBox(height: 18),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Text(
                        article.cleanContent,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16 + _fontSizeDelta,
                              height: 1.7,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _PillAction(
                          icon: Icons.share_rounded,
                          label: l10n.share,
                          onTap: () => _showShareOptions(article),
                        ),
                        _PillAction(
                          icon: isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          label: l10n.savedTitle,
                          onTap: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final bookmarkMessage = isBookmarked
                                ? l10n.removedBookmark
                                : l10n.bookmarked;

                            await ref
                                .read(bookmarkProvider.notifier)
                                .toggle(article);

                            if (!mounted) return;

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(bookmarkMessage),
                              ),
                            );
                          },
                        ),
                        _PillAction(
                          icon: Icons.open_in_new_rounded,
                          label: l10n.openInBrowser,
                          onTap: () => _openInBrowser(article.url),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () => _openInBrowser(article.url),
                      icon: const Icon(Icons.menu_book_rounded),
                      label: Text(l10n.readFullArticle),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _metaLine(BuildContext context, ArticleModel article) {
    final l10n = context.l10n;

    final date = article.publishedDate != null
        ? DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
            .format(article.publishedDate!)
        : '';

    final minutes = _estimateReadTime(article.cleanContent);

    return [
      if (date.isNotEmpty) date,
      l10n.readTimeMinutes(minutes),
    ].join(' | ');
  }

  int _estimateReadTime(String content) {
    final words = content.trim().split(RegExp(r'\s+')).length;
    return (words / 200).ceil().clamp(1, 30);
  }

  Future<void> _openInBrowser(String? url) async {
    if (url == null) return;

    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _showShareOptions(ArticleModel article) async {
    final url = article.url;
    if (url == null || !mounted) {
      return;
    }

    final l10n = context.l10n;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ShareSheetAction(
                  icon: Icons.share_rounded,
                  label: l10n.share,
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _shareArticle(article);
                  },
                ),
                const SizedBox(height: 10),
                _ShareSheetAction(
                  icon: Icons.link_rounded,
                  label: l10n.copyLink,
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _copyLink(url);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareArticle(ArticleModel article) async {
    final url = article.url;
    if (url == null || url.isEmpty || !mounted) {
      return;
    }

    final shareText = [
      if ((article.title?.trim().isNotEmpty ?? false)) article.title!.trim(),
      url,
    ].join('\n\n');

    await Share.share(
      shareText,
      subject: article.title,
    );
  }

  Future<void> _copyLink(String? url) async {
    if (url == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final copiedMessage = context.l10n.linkCopied;

    await Clipboard.setData(ClipboardData(text: url));

    if (!mounted) return;

    messenger.showSnackBar(
      SnackBar(content: Text(copiedMessage)),
    );
  }
}

class _ShareSheetAction extends StatelessWidget {
  const _ShareSheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(label),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          alignment: AlignmentDirectional.centerStart,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _PillAction extends StatelessWidget {
  const _PillAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _FontSlider extends StatelessWidget {
  const _FontSlider({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.fontSizeAdjust),
          Slider(
            value: value,
            min: -2,
            max: 4,
            divisions: 6,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
