import 'package:flutter/material.dart';

import '../features/navigation/main_navigation.dart';
import '../core/theme/app_theme.dart';

class MilesAwayApp extends StatelessWidget {
  const MilesAwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MilesAway',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainNavigation(),
    );
  }
}
