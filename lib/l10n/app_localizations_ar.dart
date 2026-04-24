// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أخبار بالس';

  @override
  String get appTagline => 'ابقَ على اطلاع دائم.';

  @override
  String get homeNav => 'الرئيسية';

  @override
  String get categoriesNav => 'الفئات';

  @override
  String get bookmarksNav => 'المحفوظة';

  @override
  String get settingsNav => 'الإعدادات';

  @override
  String get searchTitle => 'اكتشف';

  @override
  String get searchSubtitle => 'ابحث في آلاف المقالات';

  @override
  String get searchHint => 'ابحث عن الأخبار أو المواضيع أو المصادر...';

  @override
  String get searchCancel => 'إلغاء';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get clear => 'مسح';

  @override
  String get breakingNews => 'أخبار عاجلة';

  @override
  String get breakingNewsSubtitle => 'أهم القصص التي تقود النقاش الآن.';

  @override
  String get trending => 'الأكثر تداولاً';

  @override
  String get trendingSubtitle => 'قراءات سريعة يتابعها الناس باهتمام.';

  @override
  String get topStories => 'أهم القصص';

  @override
  String get readMore => 'اقرأ المزيد';

  @override
  String get readFullArticle => 'اقرأ المقال كاملاً';

  @override
  String get openInBrowser => 'افتح في المتصفح';

  @override
  String get share => 'مشاركة';

  @override
  String get copyLink => 'نسخ الرابط';

  @override
  String get linkCopied => 'تم نسخ رابط المقال';

  @override
  String get bookmarked => 'تم حفظ المقال';

  @override
  String get removedBookmark => 'تمت إزالة المقال من المحفوظات';

  @override
  String get savedTitle => 'المحفوظة';

  @override
  String get savedEmptyTitle => 'لا توجد مقالات محفوظة بعد';

  @override
  String get savedEmptyMessage =>
      'اضغط على أيقونة الحفظ في أي مقال للاحتفاظ به لوقت لاحق.';

  @override
  String savedArticlesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مقال محفوظ',
      many: '$count مقالاً محفوظاً',
      few: '$count مقالات محفوظة',
      two: 'مقالان محفوظان',
      one: 'مقال محفوظ واحد',
      zero: 'لا توجد مقالات محفوظة',
    );
    return '$_temp0';
  }

  @override
  String get clearSavedTitle => 'مسح كل المقالات المحفوظة؟';

  @override
  String get clearSavedMessage =>
      'سيؤدي هذا إلى حذف كل المقالات المحفوظة نهائياً.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get remove => 'إزالة';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get noConnection => 'لا يوجد اتصال';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get noArticlesFound => 'لم يتم العثور على مقالات.';

  @override
  String get searchEmptyTitle => 'ابدأ الاكتشاف';

  @override
  String get searchEmptyMessage =>
      'ابحث عن موضوع أو جهة نشر أو عنوان لتبني نشرتك الخاصة.';

  @override
  String searchNoResults(String query) {
    return 'لا توجد نتائج لـ \"$query\"';
  }

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationsEnabled => 'تنبيهات غير مقروءة وعناوين عاجلة';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get fontSize => 'حجم الخط';

  @override
  String get fontSmall => 'صغير';

  @override
  String get fontMedium => 'متوسط';

  @override
  String get fontLarge => 'كبير';

  @override
  String get about => 'حول التطبيق';

  @override
  String versionLabel(String version) {
    return 'الإصدار $version';
  }

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageUrdu => 'الأردية';

  @override
  String get languageFrench => 'الفرنسية';

  @override
  String get languageSpanish => 'الإسبانية';

  @override
  String get sectionSettingsSubtitle => 'خصص تجربة القراءة الخاصة بك';

  @override
  String articleBy(String author) {
    return 'بقلم $author';
  }

  @override
  String get articleUnknownAuthor => 'هيئة التحرير';

  @override
  String readTimeMinutes(int minutes) {
    return '$minutes دقائق قراءة';
  }

  @override
  String get fontSizeAdjust => 'حجم القراءة';

  @override
  String get notificationBadgeLabel => 'تنبيهات غير مقروءة';

  @override
  String get categoryTopHeadlines => 'أهم العناوين';

  @override
  String get categoryPakistan => 'باكستان';

  @override
  String get categoryInternational => 'العالم';

  @override
  String get categorySports => 'رياضة';

  @override
  String get categoryTechnology => 'تقنية';

  @override
  String get categoryBusiness => 'أعمال';

  @override
  String get categoryEntertainment => 'ترفيه';

  @override
  String get searchRecentChip => 'حديث';

  @override
  String get settingsLanguagePicker => 'اختر لغتك';

  @override
  String get settingsThemePicker => 'اختر المظهر';

  @override
  String get settingsFontPicker => 'اختر حجم الخط';
}
