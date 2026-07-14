// File: lib/providers/settings_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final String theme; // 'light', 'dark', 'green', 'red'
  final bool enableSound;
  final int vibrationIntensity; // 0 to 255 (amplitude)

  SettingsState({
    required this.theme,
    required this.enableSound,
    required this.vibrationIntensity,
  });

  SettingsState copyWith({
    String? theme,
    bool? enableSound,
    int? vibrationIntensity,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      enableSound: enableSound ?? this.enableSound,
      vibrationIntensity: vibrationIntensity ?? this.vibrationIntensity,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    Future.microtask(() => _loadSettings());
    return SettingsState(
      theme: 'dark',
      enableSound: true,
      vibrationIntensity: 100,
    );
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('settings_theme') ?? 'dark';
      final savedSound = prefs.getBool('settings_sound') ?? true;
      final savedIntensity = prefs.getInt('settings_vibration_intensity') ?? 100;
      state = SettingsState(
        theme: savedTheme,
        enableSound: savedSound,
        vibrationIntensity: savedIntensity,
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

  Future<void> setSound(bool enabled) async {
    state = state.copyWith(enableSound: enabled);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('settings_sound', enabled);
    } catch (e) {
      // Handle saving failure gracefully
    }
  }

  Future<void> setVibrationIntensity(int intensity) async {
    state = state.copyWith(vibrationIntensity: intensity);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('settings_vibration_intensity', intensity);
    } catch (e) {
      // Handle saving failure gracefully
    }
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
