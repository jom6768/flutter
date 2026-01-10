import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalInputFormatter({this.decimalRange = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return const TextEditingValue(text: '0');
    }

    // Allow only one decimal point
    if ('.'.allMatches(text).length > 1) {
      return oldValue;
    }

    // Limit decimal digits
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 1 && parts[1].length > decimalRange) {
        return oldValue;
      }
    }

    // Remove leading zero
    if (text.startsWith('0') && text.length > 1 && !text.startsWith('0.')) {
      final newText = text.substring(1);
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    return newValue;
  }
}
