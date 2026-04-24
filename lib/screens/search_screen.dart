// MODIFIED BY CODEX — UI UPGRADE
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations_ext.dart';
import '../providers/app_providers.dart';
import '../theme/app_settings_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/error_view.dart';
import '../widgets/news_card.dart';
import '../widgets/pulse_app_bar.dart';
import '../widgets/shimmer_card.dart';
import 'article_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        setState(() => _expanded = true);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (query.trim().isEmpty) {
        ref.read(searchProvider.notifier).clear();
        return;
      }
      await ref.read(searchProvider.notifier).search(query.trim());
      if (!mounted) {
        return;
      }
      await AppSettingsScope.read(context).addRecentSearch(query.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final settings = AppSettingsScope.of(context);
    final l10n = context.l10n;
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      appBar: PulseAppBar(
        title: l10n.searchTitle,
        subtitle: l10n.searchSubtitle,
        showThemeToggle: false,
        showBackButton: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(18, 14, 18, 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                height: 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.78),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.28),
                  ),
                ),
                padding: EdgeInsetsDirectional.only(
                  start: 16,
                  end: _expanded ? 8 : 16,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.violet),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: _expanded ? 1 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          onChanged: _handleSearch,
                          onSubmitted: _handleSearch,
                          decoration: InputDecoration.collapsed(
                            hintText: l10n.searchHint,
                          ),
                        ),
                      ),
                    ),
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _controller.clear();
                          ref.read(searchProvider.notifier).clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                  ],
                ),
              ),
            ),
            if (!isKeyboardOpen && settings.recentSearches.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 14, 18, 0),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l10n.recentSearches,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            if (!isKeyboardOpen && settings.recentSearches.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 18, 0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: settings.recentSearches.map((query) {
                    return InputChip(
                      label: Text(query),
                      onPressed: () {
                        _controller.text = query;
                        _handleSearch(query);
                        setState(() {});
                      },
                      onDeleted: () => settings.removeRecentSearch(query),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: _SearchBody(
                state: searchState,
                query: _controller.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBody extends ConsumerWidget {
  const _SearchBody({
    required this.state,
    required this.query,
  });

  final SearchState state;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    if (state.isSearching) {
      return ShimmerList(isDark: isDark, count: 5);
    }

    if (state.errorMessage != null) {
      return ErrorView(
        message: state.errorMessage!,
        isDark: isDark,
        onRetry: () => ref.read(searchProvider.notifier).search(query),
      );
    }

    if (query.trim().isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.violet.withValues(alpha: 0.2),
                      AppColors.secondaryAccent.withValues(alpha: 0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.travel_explore_rounded,
                  size: 52,
                  color: AppColors.violet,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.searchEmptyTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.searchEmptyMessage,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state.results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 52,
                color: AppColors.violet,
              ),
              const SizedBox(height: 18),
              Text(
                l10n.searchNoResults(query),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 2, bottom: 26),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final article = state.results[index];
        return NewsCard(
          article: article,
          layout: index == 0 ? NewsCardLayout.featured : NewsCardLayout.compact,
          index: index,
          heroTag: 'search_${article.url ?? index}',
          onTap: () => Navigator.of(context).push(
            _slideRoute(
              ArticleDetailScreen(
                article: article,
                heroTag: 'search_${article.url ?? index}',
              ),
            ),
          ),
        );
      },
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
