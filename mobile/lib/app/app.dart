import 'package:flutter/material.dart';

class MilesAwayApp extends StatelessWidget {
  const MilesAwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MilesAway',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('MilesAway'))),
    );
  }
}
