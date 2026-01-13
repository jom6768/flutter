import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/features/tax/domain/models/tax_history.dart';
import 'package:tax_calculation/features/tax/domain/services/tax_calculator.dart';
import 'package:tax_calculation/features/tax/presentation/providers/tax_provider.dart';

class TaxInput {
  final double annualIncome;
  final double providentFund;
  final double socialSecurity;
  final double lifeInsurance;
  final double healthInsurance;
  final double doubleDonation;
  final double normalDonation;

  const TaxInput({
    required this.annualIncome,
    required this.providentFund,
    required this.socialSecurity,
    required this.lifeInsurance,
    required this.healthInsurance,
    required this.doubleDonation,
    required this.normalDonation,
  });
}

final taxCalculateProvider =
    FutureProvider.family<TaxCalculationResult, TaxInput>((ref, input) async {
  final personalExpense = min(input.annualIncome * 0.5, 100000).toDouble();
  const personalDeduction = 60000.0;

  final result = TaxCalculator.calculateWithBreakdown(
    annualIncome: input.annualIncome,
    personalExpense: personalExpense,
    personalDeduction: personalDeduction,
    providentFund: input.providentFund,
    socialSecurity: input.socialSecurity,
    lifeInsurance: input.lifeInsurance,
    healthInsurance: input.healthInsurance,
    doubleDonation: input.doubleDonation,
    normalDonation: input.normalDonation,
  );

  final history = TaxHistory(
    annualIncome: input.annualIncome,
    personalExpense: personalExpense,
    personalDeduction: personalDeduction,
    providentFund: input.providentFund,
    socialSecurity: input.socialSecurity,
    lifeInsurance: input.lifeInsurance,
    healthInsurance: input.healthInsurance,
    doubleDonation: input.doubleDonation,
    normalDonation: input.normalDonation,
    tax: result.tax,
  );

  await ref.read(taxRepositoryProvider).save(history);

  return result;
});
