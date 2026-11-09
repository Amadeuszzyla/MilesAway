import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppStateType { loading, empty, error }

class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.icon,
    this.onRetry,
  });

  final AppStateType type;
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (type == AppStateType.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.green),
      );
    }

    final isError = type == AppStateType.error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ??
                  (isError ? Icons.cloud_off_outlined : Icons.explore_outlined),
              size: 52,
              color: isError ? AppColors.error : AppColors.gold,
            ),
            const SizedBox(height: 16),
            Text(
              title ??
                  (isError ? 'Coś poszło nie tak' : 'Tutaj jeszcze nic nie ma'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message ??
                  (isError
                      ? 'Nie udało się załadować danych. Spróbuj ponownie.'
                      : 'Gdy dodasz swoje podróże, pojawią się tutaj.'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (isError && onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Spróbuj ponownie'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
