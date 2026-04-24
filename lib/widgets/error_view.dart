// MODIFIED BY CODEX — UI UPGRADE
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../l10n/app_localizations_ext.dart';
import '../theme/app_theme.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    required this.isDark,
  });

  final String message;
  final VoidCallback onRetry;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isNetwork = message.toLowerCase().contains('internet') ||
        message.toLowerCase().contains('connection') ||
        message.toLowerCase().contains('timeout') ||
        message.toLowerCase().contains('socket');

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isNetwork
                          ? Icons.wifi_tethering_error_rounded
                          : Icons.newspaper_rounded,
                      size: 42,
                      color: AppColors.error,
                    ),
                  )
                      .animate()
                      .scale(duration: 450.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 20),
                  Text(
                    isNetwork ? l10n.noConnection : l10n.somethingWentWrong,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.tryAgain),
                  )
                      .animate()
                      .fadeIn(delay: 120.ms)
                      .slideY(begin: 0.2, end: 0, delay: 120.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
