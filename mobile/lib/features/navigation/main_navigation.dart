import 'package:flutter/material.dart';

import '../account/account_screen.dart';
import '../map/map_screen.dart';
import '../profile/profile_screen.dart';
import '../stats/stats_screen.dart';
import '../trips/trips_screen.dart';

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
          TripsScreen(),
          MapScreen(),
          StatsScreen(),
          ProfileScreen(),
          AccountScreen(),
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
