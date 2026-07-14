// File: lib/screens/calculator_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/calculator_provider.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcState = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);
    final theme = Theme.of(context);

    final modeTitle = calcState.isScientific ? 'Bilimsel Mod' : 'Esnaf Modu';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // 2. History Clock Icon in TOP-LEFT corner
        leading: IconButton(
          icon: const Icon(Icons.history),
          tooltip: 'Hesaplama Geçmişi',
          onPressed: () => _showHistorySheet(context, theme),
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
          // 3. Calculator Mode Selection Icon in TOP-RIGHT corner
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
              // Display scales automatically based on orientation
              const CalculatorDisplay(),
              const SizedBox(height: 12),
              // Keypad expands to fill the remaining area dynamically
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
