import 'package:flutter/material.dart';

import 'screens/root_screen.dart';
import 'state/app_controller.dart';

class MealSpinnerApp extends StatelessWidget {
  const MealSpinnerApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hôm nay ăn gì?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3169D8),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationThemeData(
          border: OutlineInputBorder(),
        ),
      ),
      home: RootScreen(controller: controller),
    );
  }
}
