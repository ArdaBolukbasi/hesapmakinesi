// File: lib/providers/settings_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final String theme; // 'light', 'dark', 'green', 'red'
  final bool useCommaDecimal; // false: 1,500.50, true: 1.500,50

  SettingsState({
    required this.theme,
    required this.useCommaDecimal,
  });

  SettingsState copyWith({
    String? theme,
    bool? useCommaDecimal,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      useCommaDecimal: useCommaDecimal ?? this.useCommaDecimal,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    Future.microtask(() => _loadSettings());
    return SettingsState(
      theme: 'dark',
      useCommaDecimal: false,
    );
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('settings_theme') ?? 'dark';
      final savedUseCommaDecimal = prefs.getBool('settings_comma_decimal') ?? false;
      state = SettingsState(
        theme: savedTheme,
        useCommaDecimal: savedUseCommaDecimal,
      );
    } catch (e) {
      // Handle loading failure gracefully
    }
  }

  Future<void> setTheme(String themeName) async {
    state = state.copyWith(theme: themeName);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('settings_theme', themeName);
    } catch (e) {
      // Handle saving failure gracefully
    }
  }

  Future<void> setUseCommaDecimal(bool useComma) async {
    state = state.copyWith(useCommaDecimal: useComma);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('settings_comma_decimal', useComma);
    } catch (e) {
      // Handle saving failure gracefully
    }
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
