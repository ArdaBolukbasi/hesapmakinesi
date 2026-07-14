// File: lib/providers/calculator_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/history_item.dart';
import '../utils/number_formatter.dart';

class CalculatorState {
  final bool isScientific;
  final String displayValue;
  final String formulaValue;
  final List<HistoryItem> history;
  final bool isDegMode;
  final bool shouldResetDisplay;

  CalculatorState({
    required this.isScientific,
    required this.displayValue,
    required this.formulaValue,
    required this.history,
    required this.isDegMode,
    required this.shouldResetDisplay,
  });

  CalculatorState copyWith({
    bool? isScientific,
    String? displayValue,
    String? formulaValue,
    List<HistoryItem>? history,
    bool? isDegMode,
    bool? shouldResetDisplay,
  }) {
    return CalculatorState(
      isScientific: isScientific ?? this.isScientific,
      displayValue: displayValue ?? this.displayValue,
      formulaValue: formulaValue ?? this.formulaValue,
      history: history ?? this.history,
      isDegMode: isDegMode ?? this.isDegMode,
      shouldResetDisplay: shouldResetDisplay ?? this.shouldResetDisplay,
    );
  }
}

class CalculatorNotifier extends Notifier<CalculatorState> {
  // Accounting State Machine variables
  double? _operandA;
  String? _operator;
  bool _isPercentCalculated = false;
  double? _lastPercentResult;
  double? _lastPercentBase;
  bool _isPercentageFinalized = false;

  final _uuid = const Uuid();

  String _format(String value) {
    return NumberFormatter.format(value);
  }

  String _formatResult(double result) {
    return NumberFormatter.formatResult(result);
  }

  @override
  CalculatorState build() {
    _resetAccountingState();
    Future.microtask(() => _loadHistory());
    return CalculatorState(
      isScientific: false,
      displayValue: '0',
      formulaValue: '',
      history: [],
      isDegMode: true,
      shouldResetDisplay: false,
    );
  }

  // Load and save tape history from SharedPreferences
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('history_tape') ?? [];
      state = state.copyWith(
        history: list.map((item) => HistoryItem.fromJson(item)).toList(),
      );
    } catch (e) {
      // Handle loading failure gracefully
    }
  }

  Future<void> _saveHistoryList(List<HistoryItem> updatedHistory) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = updatedHistory.map((item) => item.toJson()).toList();
      await prefs.setStringList('history_tape', list);
    } catch (e) {
      // Handle saving failure gracefully
    }
  }

  void _addToHistory(String expression, String result) {
    final newItem = HistoryItem(
      id: _uuid.v4(),
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
      isScientific: state.isScientific,
    );
    final updatedHistory = [newItem, ...state.history];
    state = state.copyWith(history: updatedHistory);
    _saveHistoryList(updatedHistory);
  }

  void clearHistory() {
    state = state.copyWith(history: []);
    _saveHistoryList([]);
  }

  void restoreHistoryItem(HistoryItem item) {
    if (state.isScientific) {
      String current = state.formulaValue;
      if (state.shouldResetDisplay || current == '0' || current.isEmpty) {
        current = item.result;
      } else {
        // Append result. Add + if it ends in digit or closing parenthesis.
        final cleanResult = item.result.replaceAll(',', '');
        if (RegExp(r'[\d\)]$').hasMatch(current)) {
          current = '$current+$cleanResult';
        } else {
          current = '$current$cleanResult';
        }
      }
      state = state.copyWith(
        formulaValue: current,
        displayValue: current,
        shouldResetDisplay: false,
      );
    } else {
      _resetAccountingState();
      state = state.copyWith(
        displayValue: item.result,
        formulaValue: item.result,
        shouldResetDisplay: true,
      );
    }
  }

  void toggleMode() {
    state = state.copyWith(
      isScientific: !state.isScientific,
      displayValue: '0',
      formulaValue: '',
      shouldResetDisplay: false,
    );
    _resetAccountingState();
  }

  void setMode(bool isScientific) {
    if (state.isScientific != isScientific) {
      toggleMode();
    }
  }

  void toggleDegRad() {
    state = state.copyWith(isDegMode: !state.isDegMode);
  }

  void _resetAccountingState() {
    _operandA = null;
    _operator = null;
    _isPercentCalculated = false;
    _lastPercentResult = null;
    _lastPercentBase = null;
    _isPercentageFinalized = false;
  }

  // Clear or Backspace keys
  void handleClear() {
    if (state.isScientific) {
      state = state.copyWith(
        displayValue: '0',
        formulaValue: '',
        shouldResetDisplay: false,
      );
    } else {
      _resetAccountingState();
      state = state.copyWith(
        displayValue: '0',
        formulaValue: '',
        shouldResetDisplay: false,
      );
    }
  }

  void handleBackspace() {
    _isPercentageFinalized = false;
    if (state.isScientific) {
      String formula = state.formulaValue;
      if (formula.isNotEmpty) {
        // If backspacing a function word like 'sin(', 'cos(', 'tan(', 'log(', 'ln(', 'sqrt('
        bool deletedWord = false;
        final words = ['sin(', 'cos(', 'tan(', 'log(', 'sqrt('];
        for (final word in words) {
          if (formula.endsWith(word)) {
            formula = formula.substring(0, formula.length - word.length);
            deletedWord = true;
            break;
          }
        }
        if (!deletedWord && formula.endsWith('ln(')) {
          formula = formula.substring(0, formula.length - 3);
          deletedWord = true;
        }

        if (!deletedWord) {
          formula = formula.substring(0, formula.length - 1);
        }

        state = state.copyWith(
          formulaValue: formula,
          displayValue: formula.isEmpty ? '0' : formula,
        );
      }
    } else {
      // In Accounting Mode, we backspace the active typing display
      if (state.shouldResetDisplay || _isPercentCalculated) return;
      String current = state.displayValue.replaceAll(',', '');
      if (current.isNotEmpty && current != '0') {
        current = current.substring(0, current.length - 1);
        if (current.isEmpty || current == '-') current = '0';
        state = state.copyWith(
          displayValue: _format(current),
        );
      }
    }
  }

  // Central entry point for keypad taps
  void handleKeyPress(String key) {
    if (state.isScientific) {
      _handleScientificKeyPress(key);
    } else {
      _handleAccountingKeyPress(key);
    }
  }

  // -------------------------------------------------------------
  // ACCOUNTING MODE ENGINE
  // -------------------------------------------------------------
  void _handleAccountingKeyPress(String key) {

    // Check if key is a digit or decimal point
    if (RegExp(r'[0-9.]').hasMatch(key)) {
      _isPercentageFinalized = false;
      if (state.shouldResetDisplay || _isPercentCalculated) {
        state = state.copyWith(
          displayValue: key == '.' ? '0.' : key,
          shouldResetDisplay: false,
        );
        _isPercentCalculated = false;
      } else {
        String current = state.displayValue.replaceAll(',', '');
        if (key == '.') {
          if (current.contains('.')) return;
          current = '$current.';
        } else {
          if (current == '0') {
            current = key;
          } else {
            current = '$current$key';
          }
        }
        state = state.copyWith(
          displayValue: _format(current),
        );
      }

      // Update the expression formula view
      if (_operandA != null && _operator != null) {
        state = state.copyWith(
          formulaValue: '${_formatResult(_operandA!)} $_operator ${state.displayValue}',
        );
      } else {
        state = state.copyWith(formulaValue: state.displayValue);
      }
      return;
    }

    // Check if key is an operator
    if (key == '+' || key == '-' || key == '×' || key == '÷') {
      _isPercentageFinalized = false;
      final String mappedOperator = key == '×' ? '*' : (key == '÷' ? '/' : key);

      // Case A: Just calculated percentage (e.g. 1500 * 20 % -> displays 300)
      if (_isPercentCalculated && _lastPercentBase != null && _lastPercentResult != null) {
        if (mappedOperator == '+' || mappedOperator == '-') {
          // Immediately perform desktop calculator markup/discount
          final double base = _lastPercentBase!;
          final double percentVal = _lastPercentResult!;
          final double res = mappedOperator == '+' ? base + percentVal : base - percentVal;

          final String finalDisplay = _formatResult(res);
          final String finalFormula = '${_formatResult(base)} ${_operator ?? ""} ${_formatResult(percentVal)} ${mappedOperator == '+' ? '+' : '-'}';
          
          _addToHistory(finalFormula, finalDisplay);

          _resetAccountingState();
          _operandA = res;
          _operator = mappedOperator;
          _isPercentageFinalized = true;

          state = state.copyWith(
            displayValue: finalDisplay,
            formulaValue: '$finalDisplay $key',
            shouldResetDisplay: true,
          );
        } else {
          // If multiplication/division operator follows percent, treat percent value as the new base
          final double currentVal = double.parse(state.displayValue.replaceAll(',', ''));
          _resetAccountingState();
          _operandA = currentVal;
          _operator = mappedOperator;

          state = state.copyWith(
            formulaValue: '${_formatResult(currentVal)} $key',
            shouldResetDisplay: true,
          );
        }
        return;
      }

      // Case B: Regular operator logic
      if (_operandA != null && _operator != null && !state.shouldResetDisplay) {
        // Perform left-to-right pending operation first (no BODMAS in desktop calculators)
        final double valA = _operandA!;
        final double valB = double.parse(state.displayValue.replaceAll(',', ''));
        final double res = _evaluateBasic(valA, valB, _operator!);

        if (res.isNaN || res.isInfinite) {
          state = state.copyWith(
            displayValue: 'Math Error',
            formulaValue: '',
            shouldResetDisplay: true,
          );
          _resetAccountingState();
          return;
        }

        _operandA = res;
        _operator = mappedOperator;

        state = state.copyWith(
          displayValue: _formatResult(res),
          formulaValue: '${_formatResult(res)} $key',
          shouldResetDisplay: true,
        );
      } else {
        final double currentVal = double.parse(state.displayValue.replaceAll(',', ''));
        _operandA = currentVal;
        _operator = mappedOperator;

        state = state.copyWith(
          formulaValue: '${_formatResult(_operandA!)} $key',
          shouldResetDisplay: true,
        );
      }
      return;
    }

    // Check if key is percent (%)
    if (key == '%') {
      if (_operandA != null && _operator != null) {
        final double valA = _operandA!;
        final double valB = double.parse(state.displayValue.replaceAll(',', ''));
        final double percentVal = valA * (valB / 100);

        if (_operator == '*' || _operator == '/') {
          final double res = _operator == '*' ? percentVal : valA / (valB / 100);
          final String finalDisplay = _formatResult(res);
          final String finalFormula = '${_formatResult(valA)} $key ${_formatResult(valB)}%';

          _lastPercentBase = valA;
          _lastPercentResult = res;
          _isPercentCalculated = true;

          state = state.copyWith(
            displayValue: finalDisplay,
            formulaValue: finalFormula,
            shouldResetDisplay: true,
          );
        } else if (_operator == '+' || _operator == '-') {
          // Addition/subtraction with percent completes calculation immediately on standard calculators
          final double res = _operator == '+' ? valA + percentVal : valA - percentVal;
          final String finalDisplay = _formatResult(res);
          final String finalFormula = '${_formatResult(valA)} $_operator ${_formatResult(valB)}%';

          _addToHistory(finalFormula, finalDisplay);

          _resetAccountingState();
          _operandA = res;
          _isPercentageFinalized = true;

          state = state.copyWith(
            displayValue: finalDisplay,
            formulaValue: finalFormula,
            shouldResetDisplay: true,
          );
        }
      }
      return;
    }

    // Check if key is Equals (=)
    if (key == '=') {
      if (_isPercentageFinalized) {
        return;
      }
      if (_isPercentCalculated && _lastPercentBase != null && _lastPercentResult != null) {
        final String finalFormula = '${_formatResult(_lastPercentBase!)} ${_operator ?? "*"} ${_formatResult(_lastPercentResult! / _lastPercentBase! * 100)}%';
        _addToHistory(finalFormula, state.displayValue);

        _resetAccountingState();
        state = state.copyWith(
          formulaValue: '',
          shouldResetDisplay: true,
        );
      } else if (_operandA != null && _operator != null) {
        final double valA = _operandA!;
        final double valB = double.parse(state.displayValue.replaceAll(',', ''));
        final double res = _evaluateBasic(valA, valB, _operator!);

        final String finalDisplay = _formatResult(res);
        final String finalFormula = '${_formatResult(valA)} ${_operator == '*' ? '×' : (_operator == '/' ? '÷' : _operator!)} ${_formatResult(valB)}';

        if (res.isNaN || res.isInfinite) {
          state = state.copyWith(
            displayValue: 'Math Error',
            formulaValue: '',
            shouldResetDisplay: true,
          );
          _resetAccountingState();
          return;
        }

        _addToHistory(finalFormula, finalDisplay);
        _resetAccountingState();

        state = state.copyWith(
          displayValue: finalDisplay,
          formulaValue: '',
          shouldResetDisplay: true,
        );
      }
    }
  }

  double _evaluateBasic(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return b == 0 ? double.nan : a / b;
      default:
        return b;
    }
  }

  // -------------------------------------------------------------
  // SCIENTIFIC MODE ENGINE
  // -------------------------------------------------------------
  void _handleScientificKeyPress(String key) {

    if (key == '=') {
      _evaluateScientific();
      return;
    }

    String currentFormula = state.formulaValue;

    if (state.shouldResetDisplay) {
      currentFormula = '';
      state = state.copyWith(shouldResetDisplay: false);
    }

    // Map input key to display formula
    if (key == 'sin' || key == 'cos' || key == 'tan' || key == 'log' || key == 'ln' || key == 'sqrt') {
      currentFormula += '$key(';
    } else if (key == 'x²') {
      currentFormula += '^2';
    } else if (key == 'xy') {
      currentFormula += '^';
    } else if (key == 'π') {
      currentFormula += 'π';
    } else if (key == 'e') {
      currentFormula += 'e';
    } else if (key == '×') {
      currentFormula += '×';
    } else if (key == '÷') {
      currentFormula += '÷';
    } else if (key == '+/-') {
      if (currentFormula.endsWith('-')) {
        currentFormula = currentFormula.substring(0, currentFormula.length - 1);
      } else {
        currentFormula += '-';
      }
    } else {
      currentFormula += key;
    }

    state = state.copyWith(
      formulaValue: currentFormula,
      displayValue: currentFormula,
    );
  }

  void _evaluateScientific() {
    final String expressionText = state.formulaValue;
    if (expressionText.isEmpty) return;

    try {
      // 1. Preprocess expression for math_expressions package
      String processed = expressionText;

      // Replace visually clean operators with computer math symbols
      processed = processed.replaceAll('×', '*');
      processed = processed.replaceAll('÷', '/');

      // Add implicit multiplications (e.g. 2(3) -> 2*(3), 2π -> 2*π)
      processed = _addImplicitMultiplication(processed);

      // Handle custom constants
      processed = processed.replaceAll('π', '3.1415926535897932');
      processed = processed.replaceAll('e', '2.718281828459045');

      // Handle trig conversions if DEG is active
      if (state.isDegMode) {
        processed = _wrapTrigArguments(processed);
      }

      // Convert log10(x) to ln(x) / ln(10)
      processed = _wrapLogArguments(processed);

      // 2. Parse and evaluate expression using GrammarParser & RealEvaluator
      final ExpressionParser parser = GrammarParser();
      final Expression exp = parser.parse(processed);
      final ContextModel cm = ContextModel();
      final RealEvaluator evaluator = RealEvaluator(cm);
      final num resultVal = evaluator.evaluate(exp);

      final double resultDouble = resultVal.toDouble();

      if (resultDouble.isNaN || resultDouble.isInfinite) {
        state = state.copyWith(
          displayValue: 'Math Error',
          shouldResetDisplay: true,
        );
        return;
      }

      final String formattedResult = _formatResult(resultDouble);

      // Save complete calculation to History tape
      _addToHistory(expressionText, formattedResult);

      state = state.copyWith(
        displayValue: formattedResult,
        formulaValue: formattedResult,
        shouldResetDisplay: true,
      );
    } catch (e) {
      state = state.copyWith(
        displayValue: 'Math Error',
        shouldResetDisplay: true,
      );
    }
  }

  // Pre-process for implicit multiplications
  String _addImplicitMultiplication(String formula) {
    String result = formula;

    // Digit followed by opening parenthesis or function
    result = result.replaceAllMapped(
      RegExp(r'(\d)(?=\(|sin|cos|tan|ln|log|sqrt|π|e)'),
      (match) => '${match.group(1)}*',
    );

    // Closing parenthesis or constants followed by digit
    result = result.replaceAllMapped(
      RegExp(r'(\)|π|e)(?=\d)'),
      (match) => '${match.group(1)}*',
    );

    // Closing parenthesis followed by opening parenthesis or function
    result = result.replaceAllMapped(
      RegExp(r'(\))(?=\(|sin|cos|tan|ln|log|sqrt|π|e)'),
      (match) => '${match.group(1)}*',
    );

    // Constants followed by opening parenthesis or function
    result = result.replaceAllMapped(
      RegExp(r'(π|e)(?=\()'),
      (match) => '${match.group(1)}*',
    );

    return result;
  }

  // Stack-based argument wrapping for DEG to RAD conversions
  String _wrapTrigArguments(String formula) {
    String result = formula;
    final List<String> funcs = ['sin', 'cos', 'tan'];

    for (final func in funcs) {
      int index = 0;
      while ((index = result.indexOf('$func(', index)) != -1) {
        final int startArg = index + func.length + 1; // Index directly after '('
        int braceCount = 1;
        int endArg = -1;

        for (int i = startArg; i < result.length; i++) {
          if (result[i] == '(') braceCount++;
          if (result[i] == ')') {
            braceCount--;
            if (braceCount == 0) {
              endArg = i;
              break;
            }
          }
        }

        if (endArg != -1) {
          final String arg = result.substring(startArg, endArg);
          final String wrappedArg = _wrapTrigArguments(arg); // Handle nesting recursively
          final String replacement = '($wrappedArg) * 0.017453292519943295'; // pi / 180

          result = result.replaceRange(startArg, endArg, replacement);
          // Advance past replacement to avoid re-matching
          index = index + func.length + 1 + replacement.length + 1;
        } else {
          break;
        }
      }
    }
    return result;
  }

  // Preprocessor to map log10(x) to ln(x) / ln(10)
  String _wrapLogArguments(String formula) {
    String result = formula;
    int index = 0;

    while ((index = result.indexOf('log(', index)) != -1) {
      final int startArg = index + 4; // Length of 'log(' is 4
      int braceCount = 1;
      int endArg = -1;

      for (int i = startArg; i < result.length; i++) {
        if (result[i] == '(') braceCount++;
        if (result[i] == ')') {
          braceCount--;
          if (braceCount == 0) {
            endArg = i;
            break;
          }
        }
      }

      if (endArg != -1) {
        final String arg = result.substring(startArg, endArg);
        final String wrappedArg = _wrapLogArguments(arg); // Handle nested logs recursively
        final String replacement = 'ln($wrappedArg) / ln(10)';

        result = result.replaceRange(index, endArg + 1, replacement);
        index = index + replacement.length;
      } else {
        break;
      }
    }
    return result;
  }
}

// Riverpod Provider using NotifierProvider for Riverpod 3.0 compatibility
final calculatorProvider = NotifierProvider<CalculatorNotifier, CalculatorState>(() {
  return CalculatorNotifier();
});
