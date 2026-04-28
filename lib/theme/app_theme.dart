// MODIFIED BY CODEX â€” UI UPGRADE
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF1A1A2E);
  static const Color primaryAlt = Color(0xFF0D0D1A);
  static const Color accent = Color(0xFF5C6BC0);
  static const Color violet = Color(0xFF7C4DFF);
  static const Color secondaryAccent = Color(0xFF00BFA5);
  static const Color error = Color(0xFFEF5350);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color cardLight = Color(0xFFF8F9FF);
  static const Color cardDark = Color(0xFF252535);
  static const Color pageLight = Color(0xFFF2F4FB);
  static const Color pageDark = Color(0xFF10111A);
  static const Color borderLight = Color(0xFFDDE2F2);
  static const Color borderDark = Color(0xFF34374A);
  static const Color textLight = Color(0xFF151524);
  static const Color textDark = Color(0xFFF3F4FF);
  static const Color mutedLight = Color(0xFF6A6F85);
  static const Color mutedDark = Color(0xFFB6B7C7);
  static const Color shimmerBase = Color(0xFFE7EAF8);
  static const Color shimmerHighlight = Color(0xFFF9FAFF);
  static const Color shimmerBaseDark = Color(0xFF313348);
  static const Color shimmerHighlightDark = Color(0xFF3C3F56);
}

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final seed = isDark ? AppColors.violet : AppColors.accent;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      primary: isDark ? AppColors.violet : AppColors.primary,
      secondary: AppColors.secondaryAccent,
      error: AppColors.error,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
    ).copyWith(
      surfaceContainerHighest:
          isDark ? AppColors.cardDark : AppColors.cardLight,
      outline: isDark ? AppColors.borderDark : AppColors.borderLight,
      onSurface: isDark ? AppColors.textDark : AppColors.textLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    );

    final baseText = GoogleFonts.interTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    final textTheme = baseText.copyWith(
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.15,
        color: scheme.onSurface,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        height: 1.7,
        color: scheme.onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        height: 1.55,
        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        height: 1.45,
        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
      ),
      labelLarge: GoogleFonts.robotoCondensed(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
        color: scheme.onSurface,
      ),
      labelMedium: GoogleFonts.robotoCondensed(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: scheme.onSurface,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.pageDark : AppColors.pageLight,
      textTheme: textTheme,
      dividerColor: isDark ? AppColors.borderDark : AppColors.borderLight,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 0.8,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: AppColors.secondaryAccent,
        disabledColor: scheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        labelStyle: GoogleFonts.robotoCondensed(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
                .withValues(alpha: 0.92),
        indicatorColor: AppColors.violet.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.72),
        hintStyle: textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.65)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.violet, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.violet,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryAccent;
          }
          return scheme.surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryAccent.withValues(alpha: 0.34);
          }
          return scheme.outline.withValues(alpha: 0.4);
        }),
      ),
    );
  }
}
