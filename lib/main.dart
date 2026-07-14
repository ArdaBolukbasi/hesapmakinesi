// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/settings_provider.dart';
import 'screens/calculator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: CalculatorApp(),
    ),
  );
}

class CalculatorApp extends ConsumerWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    // Dynamic ThemeData based on the selected settings theme option
    ThemeData getThemeData() {
      ColorScheme colorScheme;
      Color scaffoldColor;

      switch (settings.theme) {
        case 'light':
          colorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F62FE),
            brightness: Brightness.light,
            primary: const Color(0xFF0F62FE),
            surface: const Color(0xFFF4F6FC),
          );
          scaffoldColor = const Color(0xFFF4F6FC);
          break;
        case 'green': // Mint theme
          colorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF00B074),
            brightness: Brightness.dark,
            primary: const Color(0xFF00B074),
            surface: const Color(0xFF0C1410),
            surfaceContainerHigh: const Color(0xFF13221A),
          );
          scaffoldColor = const Color(0xFF070B09);
          break;
        case 'red': // Ruby theme
          colorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFFE53935),
            brightness: Brightness.dark,
            primary: const Color(0xFFE53935),
            surface: const Color(0xFF160A0A),
            surfaceContainerHigh: const Color(0xFF261212),
          );
          scaffoldColor = const Color(0xFF0C0505);
          break;
        case 'retro_gold':
          colorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFFF0A352),
            brightness: Brightness.dark,
            primary: const Color(0xFFF0A352),
            surface: const Color(0xFF101010),
            surfaceContainerHigh: const Color(0xFF383542),
          );
          scaffoldColor = const Color(0xFF101010);
          break;
        case 'dark':
        default:
          colorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF78A9FF),
            brightness: Brightness.dark,
            primary: const Color(0xFF78A9FF),
            surface: const Color(0xFF0B0D13),
            surfaceContainerHigh: const Color(0xFF161A26),
          );
          scaffoldColor = const Color(0xFF050608);
      }

      return ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: scaffoldColor,
        textTheme: const TextTheme(
          displayMedium: TextStyle(fontFamily: 'RobotoMono', letterSpacing: -1.0),
          headlineSmall: TextStyle(fontFamily: 'RobotoMono', letterSpacing: -0.5),
        ),
      );
    }

    return MaterialApp(
      title: 'Premium Dual Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Force dynamic themes explicitly through getThemeData()
      theme: getThemeData(),
      home: const CalculatorScreen(),
    );
  }
}
