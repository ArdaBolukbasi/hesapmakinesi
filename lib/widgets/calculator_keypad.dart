// File: lib/widgets/calculator_keypad.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../providers/calculator_provider.dart';
import '../providers/settings_provider.dart';

class CalculatorKeypad extends ConsumerWidget {
  const CalculatorKeypad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcState = ref.watch(calculatorProvider);
    final theme = Theme.of(context);

    if (calcState.isScientific) {
      return _buildScientificKeypad(context, ref, theme);
    } else {
      return _buildAccountingKeypad(context, ref, theme);
    }
  }

  Widget _buildAccountingKeypad(BuildContext context, WidgetRef ref, ThemeData theme) {
    // 4 columns x 5 rows grid (Accounting mode layout remains completely identical in layout and height)
    final notifier = ref.read(calculatorProvider.notifier);

    final List<List<KeypadButtonConfig>> layout = [
      [
        KeypadButtonConfig(text: 'AC', type: ButtonType.action, onTap: () => notifier.handleClear()),
        KeypadButtonConfig(text: '⌫', type: ButtonType.action, onTap: () => notifier.handleBackspace()),
        KeypadButtonConfig(text: '%', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('%')),
        KeypadButtonConfig(text: '÷', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('÷')),
      ],
      [
        KeypadButtonConfig(text: '7', type: ButtonType.number, onTap: () => notifier.handleKeyPress('7')),
        KeypadButtonConfig(text: '8', type: ButtonType.number, onTap: () => notifier.handleKeyPress('8')),
        KeypadButtonConfig(text: '9', type: ButtonType.number, onTap: () => notifier.handleKeyPress('9')),
        KeypadButtonConfig(text: '×', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('×')),
      ],
      [
        KeypadButtonConfig(text: '4', type: ButtonType.number, onTap: () => notifier.handleKeyPress('4')),
        KeypadButtonConfig(text: '5', type: ButtonType.number, onTap: () => notifier.handleKeyPress('5')),
        KeypadButtonConfig(text: '6', type: ButtonType.number, onTap: () => notifier.handleKeyPress('6')),
        KeypadButtonConfig(text: '-', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('-')),
      ],
      [
        KeypadButtonConfig(text: '1', type: ButtonType.number, onTap: () => notifier.handleKeyPress('1')),
        KeypadButtonConfig(text: '2', type: ButtonType.number, onTap: () => notifier.handleKeyPress('2')),
        KeypadButtonConfig(text: '3', type: ButtonType.number, onTap: () => notifier.handleKeyPress('3')),
        KeypadButtonConfig(text: '+', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('+')),
      ],
      [
        KeypadButtonConfig(text: '0', type: ButtonType.number, onTap: () => notifier.handleKeyPress('0')),
        KeypadButtonConfig(text: '00', type: ButtonType.number, onTap: () => notifier.handleKeyPress('00')),
        KeypadButtonConfig(text: '.', type: ButtonType.number, onTap: () => notifier.handleKeyPress('.')),
        KeypadButtonConfig(text: '=', type: ButtonType.equals, onTap: () => notifier.handleKeyPress('=')),
      ],
    ];

    return Column(
      children: layout.map((row) {
        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: row.map((btn) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CalculatorButton(
                    text: btn.text,
                    onTap: btn.onTap,
                    type: btn.type,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScientificKeypad(BuildContext context, WidgetRef ref, ThemeData theme) {
    // 5 columns x 7 rows grid (Completely redesigned for scientific mode)
    final notifier = ref.read(calculatorProvider.notifier);

    final List<List<KeypadButtonConfig>> layout = [
      // Row 1
      [
        KeypadButtonConfig(text: 'sin', type: ButtonType.function, onTap: () => notifier.handleKeyPress('sin')),
        KeypadButtonConfig(text: 'cos', type: ButtonType.function, onTap: () => notifier.handleKeyPress('cos')),
        KeypadButtonConfig(text: 'tan', type: ButtonType.function, onTap: () => notifier.handleKeyPress('tan')),
        KeypadButtonConfig(text: 'log', type: ButtonType.function, onTap: () => notifier.handleKeyPress('log')),
        KeypadButtonConfig(text: 'ln', type: ButtonType.function, onTap: () => notifier.handleKeyPress('ln')),
      ],
      // Row 2
      [
        KeypadButtonConfig(text: 'sqrt', type: ButtonType.function, onTap: () => notifier.handleKeyPress('sqrt')),
        KeypadButtonConfig(text: 'x²', type: ButtonType.function, onTap: () => notifier.handleKeyPress('x²')),
        KeypadButtonConfig(text: 'xy', type: ButtonType.function, onTap: () => notifier.handleKeyPress('xy')),
        KeypadButtonConfig(text: 'π', type: ButtonType.function, onTap: () => notifier.handleKeyPress('π')),
        KeypadButtonConfig(text: 'e', type: ButtonType.function, onTap: () => notifier.handleKeyPress('e')),
      ],
      // Row 3
      [
        KeypadButtonConfig(text: '(', type: ButtonType.function, onTap: () => notifier.handleKeyPress('(')),
        KeypadButtonConfig(text: ')', type: ButtonType.function, onTap: () => notifier.handleKeyPress(')')),
        KeypadButtonConfig(text: '%', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('%')),
        KeypadButtonConfig(text: '+/-', type: ButtonType.function, onTap: () => notifier.handleKeyPress('+/-')),
        KeypadButtonConfig(text: 'AC', type: ButtonType.action, onTap: () => notifier.handleClear()),
      ],
      // Row 4
      [
        KeypadButtonConfig(text: '7', type: ButtonType.number, onTap: () => notifier.handleKeyPress('7')),
        KeypadButtonConfig(text: '8', type: ButtonType.number, onTap: () => notifier.handleKeyPress('8')),
        KeypadButtonConfig(text: '9', type: ButtonType.number, onTap: () => notifier.handleKeyPress('9')),
        KeypadButtonConfig(text: '⌫', type: ButtonType.action, onTap: () => notifier.handleBackspace()),
        KeypadButtonConfig(text: '÷', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('÷')),
      ],
      // Row 5
      [
        KeypadButtonConfig(text: '4', type: ButtonType.number, onTap: () => notifier.handleKeyPress('4')),
        KeypadButtonConfig(text: '5', type: ButtonType.number, onTap: () => notifier.handleKeyPress('5')),
        KeypadButtonConfig(text: '6', type: ButtonType.number, onTap: () => notifier.handleKeyPress('6')),
        KeypadButtonConfig(text: '×', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('×')),
        KeypadButtonConfig(text: '-', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('-')),
      ],
      // Row 6
      [
        KeypadButtonConfig(text: '1', type: ButtonType.number, onTap: () => notifier.handleKeyPress('1')),
        KeypadButtonConfig(text: '2', type: ButtonType.number, onTap: () => notifier.handleKeyPress('2')),
        KeypadButtonConfig(text: '3', type: ButtonType.number, onTap: () => notifier.handleKeyPress('3')),
        KeypadButtonConfig(text: '0', type: ButtonType.number, onTap: () => notifier.handleKeyPress('0')),
        KeypadButtonConfig(text: '+', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('+')),
      ],
      // Row 7 (Ergonomic layout: 00, ., and Equals stretching across the remaining 3 columns)
      [
        KeypadButtonConfig(text: '00', type: ButtonType.number, onTap: () => notifier.handleKeyPress('00')),
        KeypadButtonConfig(text: '.', type: ButtonType.number, onTap: () => notifier.handleKeyPress('.')),
        KeypadButtonConfig(text: '=', type: ButtonType.equals, onTap: () => notifier.handleKeyPress('=')),
      ],
    ];

    return Column(
      children: List.generate(layout.length, (index) {
        final row = layout[index];
        // Ergonomic heights: top 3 scientific rows are flex 2, bottom 4 numeric/operator rows are flex 3
        final int flex = index < 3 ? 2 : 3;

        return Expanded(
          flex: flex,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: row.map((btn) {
              // Custom flex width for the Equals key in the last row to make it fill the 5-column space cleanly
              final int colFlex = (index == 6 && btn.text == '=') ? 3 : 1;
              return Expanded(
                flex: colFlex,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CalculatorButton(
                    text: btn.text,
                    onTap: btn.onTap,
                    type: btn.type,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}

enum ButtonType { number, operator, function, action, equals }

class KeypadButtonConfig {
  final String text;
  final ButtonType type;
  final VoidCallback onTap;

  KeypadButtonConfig({
    required this.text,
    required this.type,
    required this.onTap,
  });
}

class CalculatorButton extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onTap;
  final ButtonType type;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.type,
  });

  @override
  ConsumerState<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends ConsumerState<CalculatorButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _triggerFeedbackAndTap() async {
    final settings = ref.read(settingsProvider);

    // 1. Trigger custom vibration amplitude using 'vibration' package
    if (settings.vibrationIntensity > 0) {
      try {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator) {
          final duration = 30 + ((settings.vibrationIntensity / 255) * 70).toInt();
          Vibration.vibrate(
            duration: duration,
            amplitude: settings.vibrationIntensity,
          );
        }
      } catch (e) {
        // Safe fallback
      }
    }

    // 2. Play native system click sound immediately if settings.enableSound is active
    if (settings.enableSound) {
      SystemSound.play(SystemSoundType.click);
    }

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final isRetroGold = settings.theme == 'retro_gold';

    // Dynamic colors based on button type
    Color getBgColor() {
      if (isRetroGold) {
        return const Color(0xFF383542); // Retro dark purple-grey
      }

      switch (widget.type) {
        case ButtonType.number:
          return theme.colorScheme.surfaceContainerHigh;
        case ButtonType.operator:
          return theme.colorScheme.primaryContainer;
        case ButtonType.function:
          return theme.colorScheme.secondaryContainer;
        case ButtonType.action:
          return theme.colorScheme.errorContainer;
        case ButtonType.equals:
          return theme.colorScheme.primary;
      }
    }

    Color getTextColor() {
      if (isRetroGold) {
        // AC, +/- and all scientific functions are orange/gold
        final isFunctionOrAcOrNegate = widget.text == 'AC' ||
            widget.text == '+/-' ||
            widget.type == ButtonType.function;
        return isFunctionOrAcOrNegate ? const Color(0xFFF0A352) : Colors.white;
      }

      switch (widget.type) {
        case ButtonType.number:
          return theme.colorScheme.onSurface;
        case ButtonType.operator:
          return theme.colorScheme.onPrimaryContainer;
        case ButtonType.function:
          return theme.colorScheme.onSecondaryContainer;
        case ButtonType.action:
          return theme.colorScheme.onErrorContainer;
        case ButtonType.equals:
          return theme.colorScheme.onPrimary;
      }
    }

    TextStyle? getTextStyle() {
      double fontSize = 20;
      if (widget.text.length > 3) fontSize = 14;
      if (widget.text == 'sin' || widget.text == 'cos' || widget.text == 'tan' || widget.text == 'log' || widget.text == 'sqrt') {
        fontSize = 15;
      }
      return theme.textTheme.titleMedium?.copyWith(
        color: getTextColor(),
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        fontFamily: 'RobotoMono',
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _triggerFeedbackAndTap, // Trigger sound & vibration before tap callback
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: getBgColor(),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: getTextStyle(),
            ),
          ),
        ),
      ),
    );
  }
}
