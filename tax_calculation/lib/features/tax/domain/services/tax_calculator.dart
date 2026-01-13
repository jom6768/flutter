import 'package:tax_calculation/features/tax/domain/models/tax_breakdown.dart';
import 'package:tax_calculation/features/tax/domain/services/tax_bracket.dart';

class TaxCalculationResult {
  final double netIncome;
  final double tax;
  final List<TaxBreakdownRow> breakdown;

  const TaxCalculationResult({
    required this.netIncome,
    required this.tax,
    required this.breakdown,
  });
}

class TaxCalculator {
  static const List<TaxBracket> brackets = [
    TaxBracket(150000, 0.00),
    TaxBracket(150000, 0.05),
    TaxBracket(200000, 0.10),
    TaxBracket(250000, 0.15),
    TaxBracket(250000, 0.20),
    TaxBracket(1000000, 0.25),
    TaxBracket(double.infinity, 0.30),
  ];

  static TaxCalculationResult calculateWithBreakdown({
    required double annualIncome,
    required double personalExpense,
    required double personalDeduction,
    required double providentFund,
    required double socialSecurity,
    required double lifeInsurance,
    required double healthInsurance,
    required double doubleDonation,
    required double normalDonation,
  }) {
    final deduction = personalDeduction +
        providentFund +
        socialSecurity +
        lifeInsurance +
        healthInsurance +
        (2 * doubleDonation) +
        normalDonation;

    final netIncome =
        (annualIncome - personalExpense - deduction).clamp(0, double.infinity);

    double remaining = netIncome.toDouble();
    double cumulative = 0;

    final rows = <TaxBreakdownRow>[];

    double min = 0;

    for (final bracket in brackets) {
      if (remaining <= 0) break;

      final taxable = remaining > bracket.limit ? bracket.limit : remaining;

      final tax = taxable * bracket.rate;
      cumulative += tax;

      rows.add(
        TaxBreakdownRow(
          min: min,
          max: bracket.limit.isInfinite ? null : min + bracket.limit,
          rate: bracket.rate,
          taxable: taxable,
          tax: tax,
        ),
      );

      remaining -= taxable;
      min += bracket.limit;
    }

    return TaxCalculationResult(
      netIncome: netIncome.toDouble(),
      tax: cumulative,
      breakdown: rows,
    );
  }
}
