import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/paper_card.dart';
import '../../core/widgets/app_state_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<_NavigationItem> _items = [
    _NavigationItem(
      label: 'Podróże',
      icon: Icons.luggage_outlined,
      selectedIcon: Icons.luggage,
    ),
    _NavigationItem(
      label: 'Mapa',
      icon: Icons.map_outlined,
      selectedIcon: Icons.map,
    ),
    _NavigationItem(
      label: 'Statystyki',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart,
    ),
    _NavigationItem(
      label: 'Profil',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
    _NavigationItem(
      label: 'Konto',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _PlaceholderScreen(
            title: 'Moje podróże',
            subtitle: 'Wszystkie Twoje wspomnienia w jednym miejscu.',
            icon: Icons.luggage_outlined,
          ),
          _PlaceholderScreen(
            title: 'Mapa podróży',
            subtitle: 'Odkrywaj miejsca, które już odwiedziłeś.',
            icon: Icons.map_outlined,
          ),
          _PlaceholderScreen(
            title: 'Statystyki',
            subtitle: 'Sprawdzaj swoje podróżnicze osiągnięcia.',
            icon: Icons.bar_chart_outlined,
          ),
          _PlaceholderScreen(
            title: 'Profil',
            subtitle: 'Twoja podróżnicza wizytówka.',
            icon: Icons.person_outline,
          ),
          _PlaceholderScreen(
            title: 'Konto',
            subtitle: 'Ustawienia i zarządzanie kontem.',
            icon: Icons.settings_outlined,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          for (final item in _items)
            NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            ),
        ],
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaperCard(
                padding: const EdgeInsets.all(24),
                rotation: -2,
                child: SizedBox(
                  width: 104,
                  height: 104,
                  child: Icon(icon, size: 52, color: AppColors.green),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const AppStateView(
                type: AppStateType.empty,
                title: 'Pracujemy nad tą sekcją',
                message: 'Wkrótce pojawią się tutaj nowe funkcje.',
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const _DetailsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Otwórz szczegóły'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsScreen extends StatelessWidget {
  const _DetailsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szczegóły')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: PaperCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.explore_outlined,
                  size: 56,
                  color: AppColors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  'To jest podstrona MilesAway',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tutaj w przyszłości znajdą się szczegóły wybranej podróży.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Wróć'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
