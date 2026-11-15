import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/paper_card.dart';
import '../../core/widgets/scenic_header.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _notificationsEnabled = true;

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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScenicHeader(
                title: 'Konto',
                subtitle: 'Ustawienia i zarządzanie kontem.',
              ),
              const _SectionHeader(title: 'Preferencje aplikacji'),
              const SizedBox(height: 8),
              PaperCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.palette_outlined),
                      title: Text('Motyw aplikacji'),
                      subtitle: Text('Jasny (MilesAway Beige)'),
                      trailing: Text(
                        'Domyślny',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(Icons.straighten_outlined),
                      title: Text('Jednostki miar'),
                      subtitle: Text('Kilometry (km)'),
                      trailing: Text(
                        'km',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.notifications_none_outlined),
                      title: const Text('Powiadomienia'),
                      subtitle: const Text('Przypomnienia o wyjazdach'),
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const _SectionHeader(title: 'Prywatność i dane'),
              const SizedBox(height: 8),
              PaperCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.cloud_outlined),
                      title: Text('Kopia zapasowa'),
                      subtitle: Text('Lokalne przechowywanie danych'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.download_outlined),
                      title: Text('Eksport danych'),
                      subtitle: Text('Pobierz historię podróży'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const _SectionHeader(title: 'O aplikacji'),
              const SizedBox(height: 8),
              PaperCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('MilesAway'),
                      subtitle: Text('Wersja v1.0.0 (Build 2026)'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.help_outline),
                      title: Text('Centrum pomocy'),
                      subtitle: Text('Często zadawane pytania'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.gavel_outlined),
                      title: Text('Regulamin i prywatność'),
                      subtitle: Text('Warunki korzystania z aplikacji'),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.greenDark,
        ),
      ),
    );
  }
}
