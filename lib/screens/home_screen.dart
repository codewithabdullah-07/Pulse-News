// MODIFIED BY CODEX — UI UPGRADE
import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations_ext.dart';
import '../models/article_model.dart';
import '../providers/app_providers.dart';
import '../theme/app_settings_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chips.dart';
import '../widgets/error_view.dart';
import '../widgets/news_card.dart';
import '../widgets/shimmer_card.dart';
import 'article_detail_screen.dart';
import 'bookmarks_screen.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const Duration _autoRefreshInterval = Duration(minutes: 1);

  int _currentNavIndex = 0;
  Timer? _autoRefreshTimer;
  final _HomeLifecycleObserver _lifecycleObserver = _HomeLifecycleObserver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
    Future.microtask(() => _refreshAppData());
    _startAutoRefresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lifecycleObserver.onPaused = _handleAppPaused;
    _lifecycleObserver.onResumed = _handleAppResumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshAppData({bool silent = true}) async {
    final selectedCategory = ref.read(selectedCategoryProvider);
    await Future.wait([
      ref.read(newsFeedProvider.notifier).fetchNews(
            category: selectedCategory,
            silent: silent,
          ),
      ref.read(notificationsProvider.notifier).refresh(),
    ]);
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(_autoRefreshInterval, (_) {
      _refreshAppData();
    });
  }

  void _handleAppPaused() {
    _autoRefreshTimer?.cancel();
  }

  void _handleAppResumed() {
    _refreshAppData();
    _startAutoRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentNavIndex,
        children: const [
          _NewsFeedTab(showBreaking: true),
          _NewsFeedTab(showBreaking: false),
          BookmarksScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }
}

class _NewsFeedTab extends ConsumerStatefulWidget {
  const _NewsFeedTab({required this.showBreaking});

  final bool showBreaking;

  @override
  ConsumerState<_NewsFeedTab> createState() => _NewsFeedTabState();
}

class _NewsFeedTabState extends ConsumerState<_NewsFeedTab> {
  late final ScrollController _scrollController;
  late final PageController _pageController;
  Timer? _timer;
  int _currentBreakingPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _pageController = PageController(viewportFraction: 0.92);
    ref.read(categoryWatcherProvider);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 360) {
      ref.read(newsFeedProvider.notifier).loadMore();
    }
  }

  void _configureAutoplay(int itemCount, bool disableAnimations) {
    _timer?.cancel();
    if (!widget.showBreaking || itemCount <= 1 || disableAnimations) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) {
        return;
      }
      final nextPage = (_currentBreakingPage + 1) % itemCount;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(newsFeedProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final unreadCount = ref.watch(
      notificationsProvider.select((state) => state.unreadArticles.length),
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final breakingArticles = feedState.articles.take(5).toList();

    _configureAutoplay(breakingArticles.length, disableAnimations);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        color: AppColors.secondaryAccent,
        onRefresh: () => ref.read(newsFeedProvider.notifier).fetchNews(),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _HomeSliverAppBar(
              showBreaking: widget.showBreaking,
              currentCategory: selectedCategory.localizedLabel(context),
              unreadCount: unreadCount,
              onSearch: () => Navigator.of(context).push(
                _slideRoute(const SearchScreen()),
              ),
              onNotificationTap: () {
                final articles =
                    ref.read(notificationsProvider.notifier).openInbox();
                Navigator.of(context).push(
                  _slideRoute(
                    NotificationsScreen(articles: articles),
                  ),
                );
              },
              onThemeToggle: () =>
                  AppSettingsScope.read(context).quickToggleTheme(),
            ),
            if (widget.showBreaking)
              SliverToBoxAdapter(
                child: _BreakingNewsSection(
                  articles: breakingArticles,
                  currentCategory: selectedCategory.localizedLabel(context),
                  pageController: _pageController,
                  currentPage: _currentBreakingPage,
                  onPageChanged: (value) =>
                      setState(() => _currentBreakingPage = value),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 12, 18, 0),
                child: Text(
                  widget.showBreaking
                      ? context.l10n.topStories
                      : context.l10n.categoriesNav,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 8, bottom: 6),
                child: CategoryChips(),
              ),
            ),
            if (widget.showBreaking && feedState.articles.length > 3)
              SliverToBoxAdapter(
                child: _TrendingSection(
                  articles: feedState.articles.skip(1).take(8).toList(),
                  selectedCategory: selectedCategory.localizedLabel(context),
                ),
              ),
            ..._buildFeedSlivers(
              context: context,
              state: feedState,
              isDark: isDark,
              selectedCategory: selectedCategory.localizedLabel(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeedSlivers({
    required BuildContext context,
    required NewsFeedState state,
    required bool isDark,
    required String selectedCategory,
  }) {
    if (state.isLoading && state.articles.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ShimmerList(isDark: isDark, count: 5),
          ),
        ),
      ];
    }

    if (state.errorMessage != null && state.articles.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorView(
            message: state.errorMessage!,
            isDark: isDark,
            onRetry: () => ref.read(newsFeedProvider.notifier).fetchNews(),
          ),
        ),
      ];
    }

    if (state.articles.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(context.l10n.noArticlesFound),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.only(top: 8, bottom: 120),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == state.articles.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondaryAccent,
                    ),
                  ),
                );
              }

              final article = state.articles[index];
              return NewsCard(
                article: article,
                layout: index == 0 && !widget.showBreaking
                    ? NewsCardLayout.featured
                    : NewsCardLayout.compact,
                index: index,
                categoryLabel: selectedCategory,
                heroTag: 'feed_${article.url ?? index}_${widget.showBreaking}',
                onTap: () => Navigator.of(context).push(
                  _slideRoute(
                    ArticleDetailScreen(
                      article: article,
                      heroTag:
                          'feed_${article.url ?? index}_${widget.showBreaking}',
                    ),
                  ),
                ),
              );
            },
            childCount: state.articles.length + (state.isLoadingMore ? 1 : 0),
          ),
        ),
      ),
    ];
  }
}

class _HomeSliverAppBar extends StatelessWidget {
  const _HomeSliverAppBar({
    required this.showBreaking,
    required this.currentCategory,
    required this.unreadCount,
    required this.onSearch,
    required this.onNotificationTap,
    required this.onThemeToggle,
  });

  final bool showBreaking;
  final String currentCategory;
  final int unreadCount;
  final VoidCallback onSearch;
  final VoidCallback onNotificationTap;
  final VoidCallback onThemeToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topInset = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      expandedHeight: 168,
      collapsedHeight: topInset + 76,
      toolbarHeight: 76,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final minHeight = topInset + 76;
          final maxHeight = 168.0 + topInset;
          final t =
              ((constraints.maxHeight - minHeight) / (maxHeight - minHeight))
                  .clamp(0.0, 1.0);
          const horizontalPadding = 18.0;
          final contentTopPadding = topInset + (6 + (t * 6));
          final contentBottomPadding = 10.0 + (t * 6);
          final showSubtitle = t > 0.2;

          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: 0.72 + ((1 - t) * 0.16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.surfaceDark : Colors.white)
                          .withValues(
                        alpha: 0.74 + ((1 - t) * 0.12),
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color:
                            theme.colorScheme.outline.withValues(alpha: 0.34),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      contentTopPadding,
                      horizontalPadding,
                      contentBottomPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                context.l10n.appTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _HeaderIcon(
                              icon: Icons.search_rounded,
                              onTap: onSearch,
                            ),
                            _HeaderNotification(
                              unreadCount: unreadCount,
                              onTap: onNotificationTap,
                            ),
                            _HeaderIcon(
                              icon: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              onTap: onThemeToggle,
                            ),
                          ],
                        ),
                        if (showSubtitle)
                          AnimatedOpacity(
                            opacity: t,
                            duration: const Duration(milliseconds: 160),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SizedBox(
                                height: t > 0.72 ? 36 : 18,
                                child: Text(
                                  showBreaking
                                      ? context.l10n.breakingNewsSubtitle
                                      : currentCategory,
                                  maxLines: t > 0.72 ? 2 : 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.74),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class _HeaderNotification extends StatelessWidget {
  const _HeaderNotification({
    required this.unreadCount,
    required this.onTap,
  });

  final int unreadCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _HeaderIcon(
          icon: Icons.notifications_none_rounded,
          onTap: onTap,
          iconColor: unreadCount > 0 ? AppColors.error : null,
        ),
        if (unreadCount > 0)
          PositionedDirectional(
            end: -2,
            top: -4,
            child: Container(
              constraints: const BoxConstraints(minWidth: 20, minHeight: 18),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: const BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              child: Center(
                child: Text(
                  unreadCount > 9 ? '9+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.92, 0.92),
                  end: const Offset(1.05, 1.05),
                  duration: 800.ms,
                ),
          ),
        if (unreadCount > 0)
          const PositionedDirectional(
            end: 8,
            top: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: SizedBox(width: 8, height: 8),
            ),
          ),
      ],
    );
  }
}

class _BreakingNewsSection extends StatelessWidget {
  const _BreakingNewsSection({
    required this.articles,
    required this.currentCategory,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  final List<ArticleModel> articles;
  final String currentCategory;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(18, 4, 18, 12),
            child: Text(
              context.l10n.breakingNews,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: 260,
            child: PageView.builder(
              controller: pageController,
              itemCount: articles.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    _slideRoute(
                      ArticleDetailScreen(
                        article: article,
                        heroTag: 'breaking_${article.url ?? index}',
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(end: 12, start: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: 'breaking_${article.url ?? index}',
                            child: CachedNetworkImage(
                              imageUrl: article.urlToImage ?? '',
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.violet.withValues(alpha: 0.2),
                                child: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.05),
                                  Colors.black.withValues(alpha: 0.72),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            start: 16,
                            top: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryAccent
                                    .withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                currentCategory.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            start: 18,
                            end: 18,
                            bottom: 18,
                            child: Text(
                              article.title ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              articles.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: currentPage == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsetsDirectional.only(end: 6),
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? AppColors.violet
                      : AppColors.violet.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingSection extends StatelessWidget {
  const _TrendingSection({
    required this.articles,
    required this.selectedCategory,
  });

  final List<ArticleModel> articles;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 18, 12),
            child: Text(
              context.l10n.trending,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: 224,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    _slideRoute(
                      ArticleDetailScreen(
                        article: article,
                        heroTag: 'trending_${article.url ?? index}',
                      ),
                    ),
                  ),
                  child: Container(
                    width: 220,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.25),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CachedNetworkImage(
                              imageUrl: article.urlToImage ?? '',
                              width: double.infinity,
                              height: 108,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.violet.withValues(alpha: 0.15),
                                child: const Center(
                                  child: Icon(Icons.auto_stories_rounded),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectedCategory.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: AppColors.secondaryAccent),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            article.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: articles.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: l10n.homeNav,
              ),
              NavigationDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard_rounded),
                label: l10n.categoriesNav,
              ),
              NavigationDestination(
                icon: const Icon(Icons.bookmark_outline_rounded),
                selectedIcon: const Icon(Icons.bookmark_rounded),
                label: l10n.bookmarksNav,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings_rounded),
                label: l10n.settingsNav,
              ),
            ],
          ),
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
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
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

class _HomeLifecycleObserver with WidgetsBindingObserver {
  VoidCallback? onResumed;
  VoidCallback? onPaused;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed?.call();
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      onPaused?.call();
    }
  }
}
