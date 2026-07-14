// File: lib/utils/number_formatter.dart

class NumberFormatter {
  /// Formats a raw number string by adding thousands separators (commas).
  /// Keeps fractional parts intact, allowing users to type decimals.
  static String format(String value) {
    if (value.isEmpty) return "";
    if (value == "Math Error" || value == "Error") return value;

    // Check if it's already got scientific notation
    if (value.contains('e') || value.contains('E')) {
      return value;
    }

    // Split sign, integer, and decimal parts
    String cleanValue = value.replaceAll(',', '');
    bool isNegative = cleanValue.startsWith('-');
    if (isNegative) {
      cleanValue = cleanValue.substring(1);
    }

    List<String> parts = cleanValue.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Format integer part with commas (e.g. 1500 -> 1,500)
    if (integerPart.isNotEmpty) {
      // Regular expression to insert comma every 3 digits from the right
      final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      integerPart = integerPart.replaceAllMapped(reg, (Match m) => '${m[1]},');
    }

    String formatted = isNegative ? '-$integerPart' : integerPart;
    if (parts.length > 1) {
      formatted += '.$decimalPart';
    } else if (value.endsWith('.')) {
      formatted += '.';
    }

    return formatted;
  }

  /// Formats a double calculation result to a polished string.
  /// Limits precision and removes redundant trailing decimal zeros.
  static String formatResult(double result) {
    if (result.isNaN || result.isInfinite) return "Math Error";

    // Handle very large/small numbers with scientific notation
    if (result.abs() > 1e12 || (result.abs() < 1e-7 && result != 0)) {
      return result.toStringAsExponential(5);
    }

    // Check if it represents an exact integer
    if (result == result.roundToDouble()) {
      return format(result.round().toString());
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

    return format(valueString);
  }
}
