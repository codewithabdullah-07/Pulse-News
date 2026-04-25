import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_settings_controller.dart';
import '../theme/app_theme.dart';

class PulseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PulseAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onSearchTap,
    this.showThemeToggle = true,
    this.showNotification = false,
    this.unreadCount = 0,
    this.showBackButton = false,
    this.onBack,
    this.onNotificationTap,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSearchTap;
  final bool showThemeToggle;
  final bool showNotification;
  final int unreadCount;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onNotificationTap;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(84 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = AppSettingsScope.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      toolbarHeight: 84,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
                    .withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.36),
                ),
              ),
            ),
          ),
        ),
      ),
      titleSpacing: 22,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
        ],
      ),
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: _GlassIconButton(
                icon: Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_forward_rounded
                    : Icons.arrow_back_rounded,
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
              ),
            )
          : null,
      actions: [
        if (onSearchTap != null)
          _GlassIconButton(
            icon: Icons.search_rounded,
            onTap: onSearchTap!,
          ),
        if (showNotification)
          _NotificationButton(
            unreadCount: unreadCount,
            onTap: onNotificationTap ?? () {},
          ),
        if (showThemeToggle)
          _GlassIconButton(
            icon: settings.themeMode == ThemeMode.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            onTap: settings.quickToggleTheme,
          ),
        const SizedBox(width: 14),
      ],
      bottom: bottom,
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8, top: 10, bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.cardDark : Colors.white)
                .withValues(alpha: 0.68),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.22),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
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
        _GlassIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onTap,
        ),
        if (unreadCount > 0)
          PositionedDirectional(
            end: 8,
            top: 7,
            child: Container(
              width: 18,
              height: 18,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Center(
                child: Text(
                  unreadCount > 9 ? '9+' : '$unreadCount',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(0.96, 0.96),
                  end: const Offset(1.04, 1.04),
                  duration: 900.ms,
                ),
          ),
      ],
    );
  }
}
