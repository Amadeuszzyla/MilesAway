import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_state_view.dart';
import '../../core/widgets/paper_card.dart';
import '../../core/widgets/scenic_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MilesAway',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.explore_outlined, color: AppColors.green),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const ScenicHeader(
                    title: 'Profil',
                    subtitle: 'Twoja podróżnicza wizytówka.',
                    height: 110,
                  ),
                  Positioned(
                    left: 20,
                    bottom: -20,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.green, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brownDark.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_outline,
                          size: 32,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Twój Profil Podróżnika',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 2),
              const Text(
                'Użytkownik MilesAway',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(
                    child: _ProfileBadgeCard(value: '0', label: 'PODRÓŻE'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _ProfileBadgeCard(value: '0', label: 'KRAJE'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _ProfileBadgeCard(value: '0 km', label: 'DYSTANS'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PaperCard(
                padding: const EdgeInsets.all(20),
                child: const AppStateView(
                  type: AppStateType.empty,
                  icon: Icons.person_outline,
                  title: 'Profil w przygotowaniu',
                  message: 'Gdy dodasz swoje pierwsze wpisy, w tym miejscu wyświetlą się Twoje statystyki oraz zapisane miejsca.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileBadgeCard extends StatelessWidget {
  const _ProfileBadgeCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.brownDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
