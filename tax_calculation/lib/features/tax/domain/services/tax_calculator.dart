class TaxCalculator {
  static double calculate({
    required double annualIncome,
    required double personalExpense,
    required double personalDeduction,
    required double providentFund,
    required double socialSecurity,
  }) {
    final deduct = personalDeduction + providentFund + socialSecurity;
    final taxableIncome =
        (annualIncome - personalExpense - deduct).clamp(0, double.infinity);

    double tax = 0;
    double remaining = taxableIncome.toDouble();

    // Thailand progressive tax
    final brackets = [
      [150000.0, 0.00],
      [150000.0, 0.05],
      [200000.0, 0.10],
      [250000.0, 0.15],
      [250000.0, 0.20],
      [1000000.0, 0.25],
      [double.infinity, 0.30],
    ];

    for (final b in brackets) {
      final limit = b[0];
      final rate = b[1];

      final amount = remaining > limit ? limit : remaining;
      tax += amount * rate;
      remaining -= amount;

      if (remaining <= 0) break;
    }

    return tax;
  }
}
