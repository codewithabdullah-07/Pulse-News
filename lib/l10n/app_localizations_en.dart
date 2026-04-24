// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pulse News';

  @override
  String get appTagline => 'Stay informed. Always.';

  @override
  String get homeNav => 'Home';

  @override
  String get categoriesNav => 'Categories';

  @override
  String get bookmarksNav => 'Saved';

  @override
  String get settingsNav => 'Settings';

  @override
  String get searchTitle => 'Discover';

  @override
  String get searchSubtitle => 'Search thousands of articles';

  @override
  String get searchHint => 'Search news, topics, sources...';

  @override
  String get searchCancel => 'Cancel';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearAll => 'Clear all';

  @override
  String get clear => 'Clear';

  @override
  String get breakingNews => 'Breaking News';

  @override
  String get breakingNewsSubtitle =>
      'Major stories moving the conversation right now.';

  @override
  String get trending => 'Trending';

  @override
  String get trendingSubtitle => 'Fast reads people are following closely.';

  @override
  String get topStories => 'Top Stories';

  @override
  String get readMore => 'Read more';

  @override
  String get readFullArticle => 'Read Full Article';

  @override
  String get openInBrowser => 'Open in Browser';

  @override
  String get share => 'Share';

  @override
  String get copyLink => 'Copy link';

  @override
  String get linkCopied => 'Article link copied';

  @override
  String get bookmarked => 'Article saved';

  @override
  String get removedBookmark => 'Removed from saved';

  @override
  String get savedTitle => 'Saved';

  @override
  String get savedEmptyTitle => 'No saved articles yet';

  @override
  String get savedEmptyMessage =>
      'Tap the bookmark icon on any article to save it for later.';

  @override
  String savedArticlesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved articles',
      one: '1 saved article',
      zero: 'No saved articles',
    );
    return '$_temp0';
  }

  @override
  String get clearSavedTitle => 'Clear all saved articles?';

  @override
  String get clearSavedMessage =>
      'This will permanently remove all saved articles.';

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noConnection => 'No Connection';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noArticlesFound => 'No articles found.';

  @override
  String get searchEmptyTitle => 'Start exploring';

  @override
  String get searchEmptyMessage =>
      'Search for a topic, publication, or headline to build your own briefing.';

  @override
  String searchNoResults(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsEnabled => 'Unread alerts and breaking headlines';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get fontSize => 'Font Size';

  @override
  String get fontSmall => 'Small';

  @override
  String get fontMedium => 'Medium';

  @override
  String get fontLarge => 'Large';

  @override
  String get about => 'About';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageFrench => 'French';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get sectionSettingsSubtitle => 'Personalize the reading experience';

  @override
  String articleBy(String author) {
    return 'By $author';
  }

  @override
  String get articleUnknownAuthor => 'Editorial Desk';

  @override
  String readTimeMinutes(int minutes) {
    return '$minutes min read';
  }

  @override
  String get fontSizeAdjust => 'Reading size';

  @override
  String get notificationBadgeLabel => 'Unread alerts';

  @override
  String get categoryTopHeadlines => 'Top Headlines';

  @override
  String get categoryPakistan => 'Pakistan';

  @override
  String get categoryInternational => 'Global';

  @override
  String get categorySports => 'Sports';

  @override
  String get categoryTechnology => 'Technology';

  @override
  String get categoryBusiness => 'Business';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get searchRecentChip => 'Recent';

  @override
  String get settingsLanguagePicker => 'Choose your language';

  @override
  String get settingsThemePicker => 'Choose your theme';

  @override
  String get settingsFontPicker => 'Choose your font size';
}
