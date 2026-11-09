import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_state_view.dart';
import '../../core/widgets/paper_card.dart';
import '../../core/widgets/scenic_header.dart';
import '../map/map_screen.dart' show DetailsScreen;

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  int _selectedFilterIndex = 0;

  final List<String> _filters = const ['Wszystkie', 'Planowane', 'Zakończone'];

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
                title: 'Moje podróże',
                subtitle: 'Twój osobisty dziennik wypraw.',
                height: 110,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    final isSelected = _selectedFilterIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_filters[index]),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilterIndex = index;
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
              PaperCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const AppStateView(
                      type: AppStateType.empty,
                      icon: Icons.luggage_outlined,
                      title: 'Twoja podróżnicza historia zaczyna się tutaj',
                      message: 'Dodane podróże i wspomnienia będą pojawiać się w tym miejscu.',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DetailsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Otwórz szczegóły'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
