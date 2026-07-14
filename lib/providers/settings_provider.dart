// File: lib/providers/settings_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final String theme; // 'light', 'dark', 'green', 'red'
  final bool enableVibration;
  final bool enableSound;

  SettingsState({
    required this.theme,
    required this.enableVibration,
    required this.enableSound,
  });

  SettingsState copyWith({
    String? theme,
    bool? enableVibration,
    bool? enableSound,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      enableVibration: enableVibration ?? this.enableVibration,
      enableSound: enableSound ?? this.enableSound,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    Future.microtask(() => _loadSettings());
    return SettingsState(
      theme: 'dark',
      enableVibration: true,
      enableSound: true,
    );
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('settings_theme') ?? 'dark';
      final savedVibration = prefs.getBool('settings_vibration') ?? true;
      final savedSound = prefs.getBool('settings_sound') ?? true;
      state = SettingsState(
        theme: savedTheme,
        enableVibration: savedVibration,
        enableSound: savedSound,
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

  Future<void> setVibration(bool enabled) async {
    state = state.copyWith(enableVibration: enabled);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('settings_vibration', enabled);
    } catch (e) {
      // Handle saving failure gracefully
    }
  }

  Future<void> setSound(bool enabled) async {
    state = state.copyWith(enableSound: enabled);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('settings_sound', enabled);
    } catch (e) {
      // Handle saving failure gracefully
    }
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
