import 'package:intl/intl.dart';

final _displayFormatter = NumberFormat('#,##0.00');
final _editFormatter = NumberFormat('#.##');

String formatForDisplay(double value) {
  return _displayFormatter.format(value);
}

String formatForEdit(double value) {
  return _editFormatter.format(value);
}

double parseNumber(String text) {
  return double.tryParse(text.replaceAll(',', '')) ?? 0;
}
