class TaxHistory {
  final int? id;
  final double annualIncome;
  final double personalExpense;
  final double personalDeduction;
  final double providentFund;
  final double socialSecurity;
  final double lifeInsurance;
  final double healthInsurance;
  final double doubleDonation;
  final double normalDonation;
  final double tax;

  TaxHistory({
    this.id,
    required this.annualIncome,
    required this.personalExpense,
    required this.personalDeduction,
    required this.providentFund,
    required this.socialSecurity,
    required this.lifeInsurance,
    required this.healthInsurance,
    required this.doubleDonation,
    required this.normalDonation,
    required this.tax,
  });

  TaxHistory copyWith({
    int? id,
    double? annualIncome,
    double? personalExpense,
    double? personalDeduction,
    double? providentFund,
    double? socialSecurity,
    double? lifeInsurance,
    double? healthInsurance,
    double? doubleDonation,
    double? normalDonation,
    double? tax,
  }) {
    return TaxHistory(
      id: id ?? this.id,
      annualIncome: annualIncome ?? this.annualIncome,
      personalExpense: personalExpense ?? this.personalExpense,
      personalDeduction: personalDeduction ?? this.personalDeduction,
      providentFund: providentFund ?? this.providentFund,
      socialSecurity: socialSecurity ?? this.socialSecurity,
      lifeInsurance: lifeInsurance ?? this.lifeInsurance,
      healthInsurance: healthInsurance ?? this.healthInsurance,
      doubleDonation: doubleDonation ?? this.doubleDonation,
      normalDonation: normalDonation ?? this.normalDonation,
      tax: tax ?? this.tax,
    );
  }
}

class TaxBracket {
  final double limit;
  final double rate;

  const TaxBracket(this.limit, this.rate);
}

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
