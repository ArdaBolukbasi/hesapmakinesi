// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/calculator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: CalculatorApp(),
    ),
  );
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom premium color palettes using HSL-based Material 3 colors
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F62FE), // Sleek, modern tech blue
      brightness: Brightness.light,
      primary: const Color(0xFF0F62FE),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFD0E1FF),
      onPrimaryContainer: const Color(0xFF001C5A),
      secondaryContainer: const Color(0xFFE2E2E9),
      onSecondaryContainer: const Color(0xFF141A25),
      surface: const Color(0xFFF4F6FC),
      surfaceContainerHigh: const Color(0xFFEBEFF8),
      surfaceContainerLowest: Colors.white,
      onSurface: const Color(0xFF1A1C1E),
      onSurfaceVariant: const Color(0xFF43474E),
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF78A9FF),
      brightness: Brightness.dark,
      primary: const Color(0xFF78A9FF),
      onPrimary: const Color(0xFF002D89),
      primaryContainer: const Color(0xFF0043C0),
      onPrimaryContainer: const Color(0xFFD0E1FF),
      secondaryContainer: const Color(0xFF2C303B),
      onSecondaryContainer: const Color(0xFFE2E2E9),
      surface: const Color(0xFF0B0D13),
      surfaceContainerHigh: const Color(0xFF161A26),
      surfaceContainerLowest: const Color(0xFF000000),
      onSurface: const Color(0xFFE2E2E6),
      onSurfaceVariant: const Color(0xFFC3C6CF),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
    );

    return MaterialApp(
      title: 'Premium Dual Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Elegant, automatic Light/Dark mode
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: lightColorScheme.surface,
        textTheme: const TextTheme(
          displayMedium: TextStyle(fontFamily: 'RobotoMono', letterSpacing: -1.0),
          headlineSmall: TextStyle(fontFamily: 'RobotoMono', letterSpacing: -0.5),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: darkColorScheme.surface,
        textTheme: const TextTheme(
          displayMedium: TextStyle(fontFamily: 'RobotoMono', letterSpacing: -1.0),
          headlineSmall: TextStyle(fontFamily: 'RobotoMono', letterSpacing: -0.5),
        ),
      ),
      home: const CalculatorScreen(),
    );
  }
}
