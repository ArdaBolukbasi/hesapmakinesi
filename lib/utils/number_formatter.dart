// File: lib/utils/number_formatter.dart

class NumberFormatter {
  /// Swaps commas and dots in a formatted number string
  /// e.g. "1,500.50" -> "1.500,50"
  static String _swapSeparators(String formatted) {
    return formatted
        .replaceAll(',', 'PLACEHOLDER')
        .replaceAll('.', ',')
        .replaceAll('PLACEHOLDER', '.');
  }

  /// Formats a raw number string by adding thousands separators.
  /// Keeps fractional parts intact, allowing users to type decimals.
  static String format(String value, {bool useCommaDecimal = false}) {
    if (value.isEmpty) return "";
    if (value == "Math Error" || value == "Error") return value;

    // Check if it's already got scientific notation
    if (value.contains('e') || value.contains('E')) {
      return value;
    }

    // Split sign, integer, and decimal parts
    // Always parse using standard format internally (removing dots and commas)
    String cleanValue = value.replaceAll(',', '').replaceAll('.', '.'); 
    bool isNegative = cleanValue.startsWith('-');
    if (isNegative) {
      cleanValue = cleanValue.substring(1);
    }

    List<String> parts = cleanValue.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Format integer part with commas (standard notation: 1500 -> 1,500)
    if (integerPart.isNotEmpty) {
      final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      integerPart = integerPart.replaceAllMapped(reg, (Match m) => '${m[1]},');
    }

    String formatted = isNegative ? '-$integerPart' : integerPart;
    if (parts.length > 1) {
      formatted += '.$decimalPart';
    } else if (value.endsWith('.') || value.endsWith(',')) {
      // Keep trailing decimal separator for typing
      formatted += '.';
    }

    if (useCommaDecimal) {
      formatted = _swapSeparators(formatted);
    }

    return formatted;
  }

  /// Formats a double calculation result to a polished string.
  /// Limits precision and removes redundant trailing decimal zeros.
  static String formatResult(double result, {bool useCommaDecimal = false}) {
    if (result.isNaN || result.isInfinite) return "Math Error";

    // Handle very large/small numbers with scientific notation
    if (result.abs() > 1e12 || (result.abs() < 1e-7 && result != 0)) {
      String expResult = result.toStringAsExponential(5);
      if (useCommaDecimal) {
        expResult = _swapSeparators(expResult);
      }
      return expResult;
    }

    // Check if it represents an exact integer
    if (result == result.roundToDouble()) {
      return format(result.round().toString(), useCommaDecimal: useCommaDecimal);
    }

    // Format with max precision of 10 digits
    String valueString = result.toStringAsFixed(10);
    if (valueString.contains('.')) {
      // Strip trailing zeros
      while (valueString.endsWith('0')) {
        valueString = valueString.substring(0, valueString.length - 1);
      }
      if (valueString.endsWith('.')) {
        valueString = valueString.substring(0, valueString.length - 1);
      }
    }

    return format(valueString, useCommaDecimal: useCommaDecimal);
  }
}
