import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../l10n/app_localizations_ext.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _navigationTimer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          settings: const RouteSettings(name: 'home'),
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 420),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = context.l10n;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? AppColors.primaryAlt : Colors.white,
              isDark ? AppColors.pageDark : AppColors.pageLight,
              AppColors.violet.withValues(alpha: isDark ? 0.22 : 0.12),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 34),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.surfaceDark : Colors.white)
                      .withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.28),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) => Transform.scale(
                        scale: 1 + (_pulseController.value * 0.12),
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondaryAccent
                                    .withValues(alpha: 0.18),
                                blurRadius: 26,
                                offset: const Offset(0, 12),
                              ),
                              BoxShadow(
                                color: AppColors.violet.withValues(alpha: 0.16),
                                blurRadius: 36,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Image.asset(
                              'assets/images/app_icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.appTitle,
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 150.ms)
                        .slideY(begin: 0.1, end: 0, delay: 150.ms),
                    const SizedBox(height: 8),
                    Text(
                      l10n.appTagline,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 280.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
