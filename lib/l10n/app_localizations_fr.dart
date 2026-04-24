// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pulse News';

  @override
  String get appTagline => 'Restez informé. Toujours.';

  @override
  String get homeNav => 'Accueil';

  @override
  String get categoriesNav => 'Catégories';

  @override
  String get bookmarksNav => 'Enregistrés';

  @override
  String get settingsNav => 'Paramètres';

  @override
  String get searchTitle => 'Découvrir';

  @override
  String get searchSubtitle => 'Recherchez parmi des milliers d’articles';

  @override
  String get searchHint => 'Rechercher des actualités, sujets, sources...';

  @override
  String get searchCancel => 'Annuler';

  @override
  String get recentSearches => 'Recherches récentes';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get clear => 'Effacer';

  @override
  String get breakingNews => 'Dernière minute';

  @override
  String get breakingNewsSubtitle =>
      'Les grands sujets qui font l’actualité en ce moment.';

  @override
  String get trending => 'Tendance';

  @override
  String get trendingSubtitle =>
      'Des lectures rapides que tout le monde suit de près.';

  @override
  String get topStories => 'À la une';

  @override
  String get readMore => 'Lire plus';

  @override
  String get readFullArticle => 'Lire l’article complet';

  @override
  String get openInBrowser => 'Ouvrir dans le navigateur';

  @override
  String get share => 'Partager';

  @override
  String get copyLink => 'Copier le lien';

  @override
  String get linkCopied => 'Lien de l’article copié';

  @override
  String get bookmarked => 'Article enregistré';

  @override
  String get removedBookmark => 'Retiré des enregistrements';

  @override
  String get savedTitle => 'Enregistrés';

  @override
  String get savedEmptyTitle => 'Aucun article enregistré';

  @override
  String get savedEmptyMessage =>
      'Touchez l’icône de signet sur un article pour le retrouver plus tard.';

  @override
  String savedArticlesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles enregistrés',
      one: '1 article enregistré',
      zero: 'Aucun article enregistré',
    );
    return '$_temp0';
  }

  @override
  String get clearSavedTitle => 'Effacer tous les articles enregistrés ?';

  @override
  String get clearSavedMessage =>
      'Cela supprimera définitivement tous les articles enregistrés.';

  @override
  String get cancel => 'Annuler';

  @override
  String get remove => 'Supprimer';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get noConnection => 'Pas de connexion';

  @override
  String get somethingWentWrong => 'Une erreur s’est produite';

  @override
  String get noArticlesFound => 'Aucun article trouvé.';

  @override
  String get searchEmptyTitle => 'Commencez à explorer';

  @override
  String get searchEmptyMessage =>
      'Recherchez un sujet, une publication ou un titre pour créer votre briefing.';

  @override
  String searchNoResults(String query) {
    return 'Aucun résultat pour « $query »';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsEnabled =>
      'Alertes non lues et infos de dernière minute';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get fontSize => 'Taille du texte';

  @override
  String get fontSmall => 'Petit';

  @override
  String get fontMedium => 'Moyen';

  @override
  String get fontLarge => 'Grand';

  @override
  String get about => 'À propos';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageArabic => 'Arabe';

  @override
  String get languageUrdu => 'Ourdou';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Espagnol';

  @override
  String get sectionSettingsSubtitle =>
      'Personnalisez votre expérience de lecture';

  @override
  String articleBy(String author) {
    return 'Par $author';
  }

  @override
  String get articleUnknownAuthor => 'Rédaction';

  @override
  String readTimeMinutes(int minutes) {
    return '$minutes min de lecture';
  }

  @override
  String get fontSizeAdjust => 'Taille de lecture';

  @override
  String get notificationBadgeLabel => 'Alertes non lues';

  @override
  String get categoryTopHeadlines => 'À la une';

  @override
  String get categoryPakistan => 'Pakistan';

  @override
  String get categoryInternational => 'Monde';

  @override
  String get categorySports => 'Sport';

  @override
  String get categoryTechnology => 'Technologie';

  @override
  String get categoryBusiness => 'Économie';

  @override
  String get categoryEntertainment => 'Divertissement';

  @override
  String get searchRecentChip => 'Récent';

  @override
  String get settingsLanguagePicker => 'Choisissez votre langue';

  @override
  String get settingsThemePicker => 'Choisissez votre thème';

  @override
  String get settingsFontPicker => 'Choisissez votre taille de texte';
}
