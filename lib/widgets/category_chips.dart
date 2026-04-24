// MODIFIED BY CODEX — UI UPGRADE
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations_ext.dart';
import '../models/category_model.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
        itemBuilder: (context, index) {
          final category = NewsCategory.values[index];
          final isActive = category == selected;

          return _CategoryChip(
            category: category,
            isActive: isActive,
            onTap: () {
              if (!isActive) {
                ref.read(selectedCategoryProvider.notifier).state = category;
                ref
                    .read(newsFeedProvider.notifier)
                    .fetchNews(category: category);
              }
            },
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: NewsCategory.values.length,
      ),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  const _CategoryChip({
    required this.category,
    required this.isActive,
    required this.onTap,
  });

  final NewsCategory category;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const activeColor = AppColors.secondaryAccent;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? activeColor
                : theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: widget.isActive
                  ? activeColor
                  : theme.colorScheme.outline.withValues(alpha: 0.45),
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.28),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.category.icon,
                size: 14,
                color: widget.isActive
                    ? Colors.white
                    : (isDark ? AppColors.textDark : AppColors.textLight),
              ),
              const SizedBox(width: 7),
              Text(
                widget.category.localizedLabel(context).toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: widget.isActive
                      ? Colors.white
                      : (isDark ? AppColors.textDark : AppColors.textLight),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 220.ms).slideX(begin: 0.06, end: 0);
  }
}
