// File: lib/widgets/calculator_keypad.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/calculator_provider.dart';
import '../providers/settings_provider.dart';

class CalculatorKeypad extends ConsumerWidget {
  const CalculatorKeypad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcState = ref.watch(calculatorProvider);
    final theme = Theme.of(context);
    
    // Watch settings to determine localized decimal separator symbol
    final useComma = ref.watch(settingsProvider).useCommaDecimal;
    final decimalLabel = useComma ? ',' : '.';

    if (calcState.isScientific) {
      return _buildScientificKeypad(context, ref, theme, decimalLabel);
    } else {
      return _buildAccountingKeypad(context, ref, theme, decimalLabel);
    }
  }

  Widget _buildAccountingKeypad(BuildContext context, WidgetRef ref, ThemeData theme, String decimalLabel) {
    // 4 columns x 5 rows grid
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
        KeypadButtonConfig(text: decimalLabel, type: ButtonType.number, onTap: () => notifier.handleKeyPress('.')),
        KeypadButtonConfig(text: '=', type: ButtonType.equals, onTap: () => notifier.handleKeyPress('=')),
      ],
    ];

    return Column(
      children: layout.map((row) {
        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Force buttons to expand vertically
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

  Widget _buildScientificKeypad(BuildContext context, WidgetRef ref, ThemeData theme, String decimalLabel) {
    // 5 columns x 6 rows grid
    final notifier = ref.read(calculatorProvider.notifier);

    final List<List<KeypadButtonConfig>> layout = [
      [
        KeypadButtonConfig(text: 'sin', type: ButtonType.function, onTap: () => notifier.handleKeyPress('sin')),
        KeypadButtonConfig(text: 'cos', type: ButtonType.function, onTap: () => notifier.handleKeyPress('cos')),
        KeypadButtonConfig(text: 'tan', type: ButtonType.function, onTap: () => notifier.handleKeyPress('tan')),
        KeypadButtonConfig(text: 'log', type: ButtonType.function, onTap: () => notifier.handleKeyPress('log')),
        KeypadButtonConfig(text: 'ln', type: ButtonType.function, onTap: () => notifier.handleKeyPress('ln')),
      ],
      [
        KeypadButtonConfig(text: 'sqrt', type: ButtonType.function, onTap: () => notifier.handleKeyPress('sqrt')),
        KeypadButtonConfig(text: '(', type: ButtonType.function, onTap: () => notifier.handleKeyPress('(')),
        KeypadButtonConfig(text: ')', type: ButtonType.function, onTap: () => notifier.handleKeyPress(')')),
        KeypadButtonConfig(text: 'xy', type: ButtonType.function, onTap: () => notifier.handleKeyPress('xy')),
        KeypadButtonConfig(text: 'x²', type: ButtonType.function, onTap: () => notifier.handleKeyPress('x²')),
      ],
      [
        KeypadButtonConfig(text: 'π', type: ButtonType.function, onTap: () => notifier.handleKeyPress('π')),
        KeypadButtonConfig(text: 'e', type: ButtonType.function, onTap: () => notifier.handleKeyPress('e')),
        KeypadButtonConfig(text: '%', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('%')),
        KeypadButtonConfig(text: '⌫', type: ButtonType.action, onTap: () => notifier.handleBackspace()),
        KeypadButtonConfig(text: 'AC', type: ButtonType.action, onTap: () => notifier.handleClear()),
      ],
      [
        KeypadButtonConfig(text: '7', type: ButtonType.number, onTap: () => notifier.handleKeyPress('7')),
        KeypadButtonConfig(text: '8', type: ButtonType.number, onTap: () => notifier.handleKeyPress('8')),
        KeypadButtonConfig(text: '9', type: ButtonType.number, onTap: () => notifier.handleKeyPress('9')),
        KeypadButtonConfig(text: '÷', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('÷')),
        KeypadButtonConfig(text: '×', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('×')),
      ],
      [
        KeypadButtonConfig(text: '4', type: ButtonType.number, onTap: () => notifier.handleKeyPress('4')),
        KeypadButtonConfig(text: '5', type: ButtonType.number, onTap: () => notifier.handleKeyPress('5')),
        KeypadButtonConfig(text: '6', type: ButtonType.number, onTap: () => notifier.handleKeyPress('6')),
        KeypadButtonConfig(text: '-', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('-')),
        KeypadButtonConfig(text: '+', type: ButtonType.operator, onTap: () => notifier.handleKeyPress('+')),
      ],
      [
        KeypadButtonConfig(text: '1', type: ButtonType.number, onTap: () => notifier.handleKeyPress('1')),
        KeypadButtonConfig(text: '2', type: ButtonType.number, onTap: () => notifier.handleKeyPress('2')),
        KeypadButtonConfig(text: '3', type: ButtonType.number, onTap: () => notifier.handleKeyPress('3')),
        KeypadButtonConfig(text: '0', type: ButtonType.number, onTap: () => notifier.handleKeyPress('0')),
        KeypadButtonConfig(text: decimalLabel, type: ButtonType.number, onTap: () => notifier.handleKeyPress('.')),
        KeypadButtonConfig(text: '=', type: ButtonType.equals, onTap: () => notifier.handleKeyPress('=')),
      ],
    ];

    return Column(
      children: layout.map((row) {
        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Force buttons to expand vertically
            children: row.map((btn) {
              return Expanded(
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
      }).toList(),
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

class CalculatorButton extends StatefulWidget {
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
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dynamic colors based on button type
    Color getBgColor() {
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
      onTap: widget.onTap,
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
