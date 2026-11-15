import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_state_view.dart';
import '../../core/widgets/paper_card.dart';
import '../../core/widgets/scenic_header.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _selectedYearIndex = 0;

  final List<String> _years = const ['Wszystkie lata', '2026', '2025'];

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
              const ScenicHeader(
                title: 'Statystyki',
                subtitle: 'Podsumowanie Twoich podróżniczych osiągnięć.',
                height: 110,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_years.length, (index) {
                    final isSelected = _selectedYearIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_years[index]),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedYearIndex = index;
                            });
                          }
                        },
                        selectedColor: AppColors.green,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.divider),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Expanded(
                    child: _StatMetricCard(
                      icon: Icons.luggage_outlined,
                      iconColor: AppColors.green,
                      value: '0',
                      label: 'PODRÓŻE',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatMetricCard(
                      icon: Icons.flag_outlined,
                      iconColor: AppColors.gold,
                      value: '0',
                      label: 'KRAJE',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _StatMetricCard(
                      icon: Icons.place_outlined,
                      iconColor: AppColors.terracotta,
                      value: '0',
                      label: 'ODWIEDZONE MIEJSCA',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatMetricCard(
                      icon: Icons.explore_outlined,
                      iconColor: AppColors.greenDark,
                      value: '0 km',
                      label: 'ŁĄCZNY DYSTANS',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PaperCard(
                padding: const EdgeInsets.all(20),
                child: const AppStateView(
                  type: AppStateType.empty,
                  icon: Icons.bar_chart_outlined,
                  title: 'Brak danych do statystyk',
                  message: 'Gdy dodasz swoje podróże, w tym miejscu zobaczysz podsumowanie wyjazdów i statystyki przebytych tras.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatMetricCard extends StatelessWidget {
  const _StatMetricCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PaperCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
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
