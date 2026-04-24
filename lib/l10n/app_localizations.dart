import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ur')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pulse News'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Stay informed. Always.'**
  String get appTagline;

  /// No description provided for @homeNav.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNav;

  /// No description provided for @categoriesNav.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesNav;

  /// No description provided for @bookmarksNav.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get bookmarksNav;

  /// No description provided for @settingsNav.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsNav;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get searchTitle;

  /// No description provided for @searchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search thousands of articles'**
  String get searchSubtitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search news, topics, sources...'**
  String get searchHint;

  /// No description provided for @searchCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get searchCancel;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @breakingNews.
  ///
  /// In en, this message translates to:
  /// **'Breaking News'**
  String get breakingNews;

  /// No description provided for @breakingNewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Major stories moving the conversation right now.'**
  String get breakingNewsSubtitle;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @trendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast reads people are following closely.'**
  String get trendingSubtitle;

  /// No description provided for @topStories.
  ///
  /// In en, this message translates to:
  /// **'Top Stories'**
  String get topStories;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readFullArticle.
  ///
  /// In en, this message translates to:
  /// **'Read Full Article'**
  String get readFullArticle;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get openInBrowser;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Article link copied'**
  String get linkCopied;

  /// No description provided for @bookmarked.
  ///
  /// In en, this message translates to:
  /// **'Article saved'**
  String get bookmarked;

  /// No description provided for @removedBookmark.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved'**
  String get removedBookmark;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved articles yet'**
  String get savedEmptyTitle;

  /// No description provided for @savedEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark icon on any article to save it for later.'**
  String get savedEmptyMessage;

  /// No description provided for @savedArticlesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No saved articles} =1{1 saved article} other{{count} saved articles}}'**
  String savedArticlesCount(num count);

  /// No description provided for @clearSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all saved articles?'**
  String get clearSavedTitle;

  /// No description provided for @clearSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove all saved articles.'**
  String get clearSavedMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get noConnection;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noArticlesFound.
  ///
  /// In en, this message translates to:
  /// **'No articles found.'**
  String get noArticlesFound;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start exploring'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Search for a topic, publication, or headline to build your own briefing.'**
  String get searchEmptyMessage;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String searchNoResults(String query);

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Unread alerts and breaking headlines'**
  String get notificationsEnabled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @fontSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSmall;

  /// No description provided for @fontMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fontMedium;

  /// No description provided for @fontLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontLarge;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @sectionSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize the reading experience'**
  String get sectionSettingsSubtitle;

  /// No description provided for @articleBy.
  ///
  /// In en, this message translates to:
  /// **'By {author}'**
  String articleBy(String author);

  /// No description provided for @articleUnknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Editorial Desk'**
  String get articleUnknownAuthor;

  /// No description provided for @readTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String readTimeMinutes(int minutes);

  /// No description provided for @fontSizeAdjust.
  ///
  /// In en, this message translates to:
  /// **'Reading size'**
  String get fontSizeAdjust;

  /// No description provided for @notificationBadgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Unread alerts'**
  String get notificationBadgeLabel;

  /// No description provided for @categoryTopHeadlines.
  ///
  /// In en, this message translates to:
  /// **'Top Headlines'**
  String get categoryTopHeadlines;

  /// No description provided for @categoryPakistan.
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get categoryPakistan;

  /// No description provided for @categoryInternational.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get categoryInternational;

  /// No description provided for @categorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get categorySports;

  /// No description provided for @categoryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get categoryTechnology;

  /// No description provided for @categoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get categoryBusiness;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @searchRecentChip.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get searchRecentChip;

  /// No description provided for @settingsLanguagePicker.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get settingsLanguagePicker;

  /// No description provided for @settingsThemePicker.
  ///
  /// In en, this message translates to:
  /// **'Choose your theme'**
  String get settingsThemePicker;

  /// No description provided for @settingsFontPicker.
  ///
  /// In en, this message translates to:
  /// **'Choose your font size'**
  String get settingsFontPicker;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
