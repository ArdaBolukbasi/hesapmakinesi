// File: lib/screens/calculator_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/calculator_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/calculator_display.dart';
import '../widgets/calculator_keypad.dart';
import '../widgets/history_tape.dart';
import 'vat_calculator_screen.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  // Helper method to display calculation history inside a sheet
  void _showHistorySheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Expanded(
                    child: HistoryTape(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Settings Drawer Widget
  Widget _buildSettingsDrawer(BuildContext context, WidgetRef ref, ThemeData theme) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    final List<Map<String, dynamic>> themeOptions = [
      {'id': 'light', 'name': 'Normal', 'color': const Color(0xFF0F62FE)},
      {'id': 'dark', 'name': 'Dark', 'color': const Color(0xFF78A9FF)},
      {'id': 'green', 'name': 'Green', 'color': const Color(0xFF00B074)},
      {'id': 'red', 'name': 'Red', 'color': const Color(0xFFE53935)},
    ];

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ayarlar',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Theme Selection Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tema Seçimi',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: themeOptions.map((opt) {
                      final isSelected = settings.theme == opt['id'];
                      return GestureDetector(
                        onTap: () => settingsNotifier.setTheme(opt['id']),
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: opt['color'],
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: theme.colorScheme.onSurface,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: opt['color'].withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        )
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              opt['name'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: isSelected ? FontWeight.bold : null,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Vibration Level Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.vibration, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      const Text(
                        'Titreşim Şiddeti',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        '${settings.vibrationIntensity}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: settings.vibrationIntensity.toDouble(),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    onChanged: (val) {
                      settingsNotifier.setVibrationIntensity(val.toInt());
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Sound Toggle
            SwitchListTile(
              secondary: Icon(Icons.volume_up, color: theme.colorScheme.primary),
              title: const Text(
                'Tuş Sesleri',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Tuş basışlarında klik sesi',
                style: TextStyle(fontSize: 12),
              ),
              value: settings.enableSound,
              onChanged: (val) {
                settingsNotifier.setSound(val);
              },
            ),
            const Divider(height: 1),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'v1.3.0 • Premium Calculator',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcState = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);
    final theme = Theme.of(context);

    final modeTitle = calcState.isScientific ? 'Bilimsel Mod' : 'Esnaf Modu';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      // 4. Drawer added for Settings
      drawer: _buildSettingsDrawer(context, ref, theme),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // 3. Hamburger icon alongside History clock icon in leading row
        leadingWidth: 110,
        leading: Builder(
          builder: (context) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: 'Ayarlar',
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'Hesaplama Geçmişi',
                  onPressed: () => _showHistorySheet(context, theme),
                ),
              ],
            );
          },
        ),
        title: Text(
          modeTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          // KDV Hesaplayıcıyı Açan Fatura İkonu
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'KDV Hesaplama',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VatCalculatorScreen(),
                ),
              );
            },
          ),
          // Mod Seçim Menüsü
          PopupMenuButton<bool>(
            icon: const Icon(Icons.calculate_outlined),
            tooltip: 'Mod Seçimi',
            onSelected: (isScientific) {
              notifier.setMode(isScientific);
            },
            itemBuilder: (context) => [
              PopupMenuItem<bool>(
                value: false,
                child: Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      color: !calcState.isScientific ? theme.colorScheme.primary : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Esnaf Modu',
                      style: TextStyle(
                        fontWeight: !calcState.isScientific ? FontWeight.bold : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<bool>(
                value: true,
                child: Row(
                  children: [
                    Icon(
                      Icons.science_outlined,
                      color: calcState.isScientific ? theme.colorScheme.primary : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Bilimsel Mod',
                      style: TextStyle(
                        fontWeight: calcState.isScientific ? FontWeight.bold : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            children: [
              const CalculatorDisplay(),
              const SizedBox(height: 12),
              const Expanded(
                child: CalculatorKeypad(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
