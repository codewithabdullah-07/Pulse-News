// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pulse News';

  @override
  String get appTagline => 'Mantente informado. Siempre.';

  @override
  String get homeNav => 'Inicio';

  @override
  String get categoriesNav => 'Categorías';

  @override
  String get bookmarksNav => 'Guardados';

  @override
  String get settingsNav => 'Ajustes';

  @override
  String get searchTitle => 'Descubrir';

  @override
  String get searchSubtitle => 'Busca entre miles de artículos';

  @override
  String get searchHint => 'Buscar noticias, temas o fuentes...';

  @override
  String get searchCancel => 'Cancelar';

  @override
  String get recentSearches => 'Búsquedas recientes';

  @override
  String get clearAll => 'Borrar todo';

  @override
  String get clear => 'Borrar';

  @override
  String get breakingNews => 'Última hora';

  @override
  String get breakingNewsSubtitle =>
      'Las historias que están marcando la conversación ahora.';

  @override
  String get trending => 'Tendencias';

  @override
  String get trendingSubtitle => 'Lecturas rápidas que todos siguen de cerca.';

  @override
  String get topStories => 'Titulares';

  @override
  String get readMore => 'Leer más';

  @override
  String get readFullArticle => 'Leer artículo completo';

  @override
  String get openInBrowser => 'Abrir en el navegador';

  @override
  String get share => 'Compartir';

  @override
  String get copyLink => 'Copiar enlace';

  @override
  String get linkCopied => 'Enlace del artículo copiado';

  @override
  String get bookmarked => 'Artículo guardado';

  @override
  String get removedBookmark => 'Eliminado de guardados';

  @override
  String get savedTitle => 'Guardados';

  @override
  String get savedEmptyTitle => 'Aún no hay artículos guardados';

  @override
  String get savedEmptyMessage =>
      'Toca el icono de marcador en cualquier artículo para guardarlo y leerlo después.';

  @override
  String savedArticlesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos guardados',
      one: '1 artículo guardado',
      zero: 'No hay artículos guardados',
    );
    return '$_temp0';
  }

  @override
  String get clearSavedTitle => '¿Borrar todos los artículos guardados?';

  @override
  String get clearSavedMessage =>
      'Esto eliminará permanentemente todos los artículos guardados.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Eliminar';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get noConnection => 'Sin conexión';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get noArticlesFound => 'No se encontraron artículos.';

  @override
  String get searchEmptyTitle => 'Empieza a explorar';

  @override
  String get searchEmptyMessage =>
      'Busca un tema, publicación o titular para crear tu propio resumen.';

  @override
  String searchNoResults(String query) {
    return 'No hay resultados para \"$query\"';
  }

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notificationsEnabled =>
      'Alertas no leídas y noticias de última hora';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get fontSize => 'Tamaño de fuente';

  @override
  String get fontSmall => 'Pequeño';

  @override
  String get fontMedium => 'Mediano';

  @override
  String get fontLarge => 'Grande';

  @override
  String get about => 'Acerca de';

  @override
  String versionLabel(String version) {
    return 'Versión $version';
  }

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageArabic => 'Árabe';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageFrench => 'Francés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get sectionSettingsSubtitle => 'Personaliza tu experiencia de lectura';

  @override
  String articleBy(String author) {
    return 'Por $author';
  }

  @override
  String get articleUnknownAuthor => 'Redacción';

  @override
  String readTimeMinutes(int minutes) {
    return '$minutes min de lectura';
  }

  @override
  String get fontSizeAdjust => 'Tamaño de lectura';

  @override
  String get notificationBadgeLabel => 'Alertas no leídas';

  @override
  String get categoryTopHeadlines => 'Titulares';

  @override
  String get categoryPakistan => 'Pakistán';

  @override
  String get categoryInternational => 'Global';

  @override
  String get categorySports => 'Deportes';

  @override
  String get categoryTechnology => 'Tecnología';

  @override
  String get categoryBusiness => 'Negocios';

  @override
  String get categoryEntertainment => 'Entretenimiento';

  @override
  String get searchRecentChip => 'Reciente';

  @override
  String get settingsLanguagePicker => 'Elige tu idioma';

  @override
  String get settingsThemePicker => 'Elige tu tema';

  @override
  String get settingsFontPicker => 'Elige tu tamaño de fuente';
}
