class TaxBreakdownRow {
  final double min;
  final double? max;
  final double rate;
  final double taxable;
  final double tax;

  const TaxBreakdownRow({
    required this.min,
    required this.max,
    required this.rate,
    required this.taxable,
    required this.tax,
  });
}
