import 'dart:math';

import 'package:tax_calculation/features/tax/domain/tax_models.dart';

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

  static TaxCalculationResult calculate({
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
        max(0, annualIncome - personalExpense - deduction).toDouble();

    double remaining = netIncome;
    double cumulative = 0;
    double lowerBound = 0;

    final rows = <TaxBreakdownRow>[];

    for (final b in brackets) {
      if (remaining <= 0) break;

      final taxable = min(remaining, b.limit);
      final tax = taxable * b.rate;

      rows.add(
        TaxBreakdownRow(
          min: lowerBound,
          max: b.limit.isInfinite ? null : lowerBound + b.limit,
          rate: b.rate,
          taxable: taxable,
          tax: tax,
        ),
      );

      remaining -= taxable;
      lowerBound += b.limit;
      cumulative += tax;
    }

    return TaxCalculationResult(
      netIncome: netIncome,
      tax: cumulative,
      breakdown: rows,
    );
  }
}
