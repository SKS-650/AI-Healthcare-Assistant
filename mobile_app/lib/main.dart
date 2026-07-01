// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/presentation/pages/home_dashboard_page.dart';

void main() {
  // The ProviderScope stores the state of all Riverpod providers
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Dashboard App',
      debugShowCheckedModeBanner: false,
      
      // Explicit light theme adjustments
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue.shade700,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Clean off-white background
        cardColor: Colors.white,
      ),
      
      // Temporary dark theme support for testing micro-interactions
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        cardColor: const Color(0xFF1E293B),
      ),
      themeMode: ThemeMode.system,
      
      // Set the Home Dashboard as the initial route entry point
      home: const HomeDashboardPage(),
    );
  }
}