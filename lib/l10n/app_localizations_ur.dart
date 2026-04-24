// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'پلس نیوز';

  @override
  String get appTagline => 'ہمیشہ باخبر رہیں۔';

  @override
  String get homeNav => 'ہوم';

  @override
  String get categoriesNav => 'زمرے';

  @override
  String get bookmarksNav => 'محفوظ';

  @override
  String get settingsNav => 'سیٹنگز';

  @override
  String get searchTitle => 'دریافت';

  @override
  String get searchSubtitle => 'ہزاروں مضامین میں تلاش کریں';

  @override
  String get searchHint => 'خبریں، موضوعات یا ذرائع تلاش کریں...';

  @override
  String get searchCancel => 'منسوخ';

  @override
  String get recentSearches => 'حالیہ تلاشیں';

  @override
  String get clearAll => 'سب صاف کریں';

  @override
  String get clear => 'صاف کریں';

  @override
  String get breakingNews => 'بریکنگ نیوز';

  @override
  String get breakingNewsSubtitle =>
      'اہم خبریں جو اس وقت گفتگو کا رخ طے کر رہی ہیں۔';

  @override
  String get trending => 'ٹرینڈنگ';

  @override
  String get trendingSubtitle => 'مختصر خبریں جن پر سب کی نظر ہے۔';

  @override
  String get topStories => 'اہم خبریں';

  @override
  String get readMore => 'مزید پڑھیں';

  @override
  String get readFullArticle => 'مکمل مضمون پڑھیں';

  @override
  String get openInBrowser => 'براؤزر میں کھولیں';

  @override
  String get share => 'شیئر';

  @override
  String get copyLink => 'لنک کاپی کریں';

  @override
  String get linkCopied => 'مضمون کا لنک کاپی ہو گیا';

  @override
  String get bookmarked => 'مضمون محفوظ ہو گیا';

  @override
  String get removedBookmark => 'محفوظ شدہ سے ہٹا دیا گیا';

  @override
  String get savedTitle => 'محفوظ';

  @override
  String get savedEmptyTitle => 'ابھی تک کوئی مضمون محفوظ نہیں';

  @override
  String get savedEmptyMessage =>
      'کسی بھی مضمون پر بک مارک آئیکن دبائیں اور بعد میں پڑھنے کے لیے محفوظ کریں۔';

  @override
  String savedArticlesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count محفوظ مضامین',
      one: '1 محفوظ مضمون',
      zero: 'کوئی محفوظ مضمون نہیں',
    );
    return '$_temp0';
  }

  @override
  String get clearSavedTitle => 'تمام محفوظ مضامین صاف کریں؟';

  @override
  String get clearSavedMessage =>
      'اس سے تمام محفوظ مضامین مستقل طور پر حذف ہو جائیں گے۔';

  @override
  String get cancel => 'منسوخ';

  @override
  String get remove => 'ہٹائیں';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get noConnection => 'کنکشن موجود نہیں';

  @override
  String get somethingWentWrong => 'کچھ غلط ہو گیا';

  @override
  String get noArticlesFound => 'کوئی مضمون نہیں ملا۔';

  @override
  String get searchEmptyTitle => 'تلاش شروع کریں';

  @override
  String get searchEmptyMessage =>
      'اپنی ذاتی بریفنگ بنانے کے لیے موضوع، اشاعت یا ہیڈ لائن تلاش کریں۔';

  @override
  String searchNoResults(String query) {
    return '\"$query\" کے لیے کوئی نتیجہ نہیں ملا';
  }

  @override
  String get notifications => 'اطلاعات';

  @override
  String get notificationsEnabled => 'غیر پڑھی گئی الرٹس اور بریکنگ ہیڈ لائنز';

  @override
  String get language => 'زبان';

  @override
  String get theme => 'تھیم';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'گہرا';

  @override
  String get fontSize => 'فونٹ سائز';

  @override
  String get fontSmall => 'چھوٹا';

  @override
  String get fontMedium => 'درمیانہ';

  @override
  String get fontLarge => 'بڑا';

  @override
  String get about => 'متعلق';

  @override
  String versionLabel(String version) {
    return 'ورژن $version';
  }

  @override
  String get languageEnglish => 'انگریزی';

  @override
  String get languageArabic => 'عربی';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get languageFrench => 'فرانسیسی';

  @override
  String get languageSpanish => 'ہسپانوی';

  @override
  String get sectionSettingsSubtitle => 'اپنے مطالعے کے تجربے کو ذاتی بنائیں';

  @override
  String articleBy(String author) {
    return 'از $author';
  }

  @override
  String get articleUnknownAuthor => 'ادارتی ڈیسک';

  @override
  String readTimeMinutes(int minutes) {
    return '$minutes منٹ مطالعہ';
  }

  @override
  String get fontSizeAdjust => 'مطالعے کا سائز';

  @override
  String get notificationBadgeLabel => 'غیر پڑھی گئی اطلاعات';

  @override
  String get categoryTopHeadlines => 'اہم سرخیاں';

  @override
  String get categoryPakistan => 'پاکستان';

  @override
  String get categoryInternational => 'عالمی';

  @override
  String get categorySports => 'کھیل';

  @override
  String get categoryTechnology => 'ٹیکنالوجی';

  @override
  String get categoryBusiness => 'کاروبار';

  @override
  String get categoryEntertainment => 'تفریح';

  @override
  String get searchRecentChip => 'حالیہ';

  @override
  String get settingsLanguagePicker => 'اپنی زبان منتخب کریں';

  @override
  String get settingsThemePicker => 'اپنی تھیم منتخب کریں';

  @override
  String get settingsFontPicker => 'اپنا فونٹ سائز منتخب کریں';
}
