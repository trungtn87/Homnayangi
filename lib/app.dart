import 'package:flutter/material.dart';

import 'screens/root_screen.dart';
import 'state/app_controller.dart';

class MealSpinnerApp extends StatelessWidget {
  const MealSpinnerApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF20242A);
    const mutedColor = Color(0xFF68717D);

    return MaterialApp(
      title: 'Hôm nay ăn gì?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4D689E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 26,
            height: 1.18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: textColor,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            height: 1.25,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            height: 1.3,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            height: 1.45,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            height: 1.35,
            color: mutedColor,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Color(0xFFF9FAFB),
          foregroundColor: textColor,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE7E9ED)),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE6E8EC),
          thickness: 1,
          space: 1,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Color(0xFF566171),
          textColor: textColor,
          minVerticalPadding: 8,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD9DDE3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD9DDE3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF4D689E),
              width: 1.4,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: RootScreen(controller: controller),
    );
  }
}
