import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/core/database/tax_database.dart';
import 'package:tax_calculation/features/tax/application/tax_calculator.dart';
import 'package:tax_calculation/features/tax/data/tax_repository.dart';
import 'package:tax_calculation/features/tax/domain/tax_models.dart';

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

final taxLoadingProvider = StateProvider<bool>((ref) => false);

final taxDatabaseProvider = Provider<TaxDatabase>((ref) {
  final db = TaxDatabase();
  ref.onDispose(db.close);
  return db;
});

final taxRepositoryProvider = Provider<TaxRepository>((ref) {
  return TaxRepositoryImpl(ref.watch(taxDatabaseProvider));
});

final taxHistoryProvider = StreamProvider<List<TaxHistory>>((ref) {
  return ref.watch(taxRepositoryProvider).watchHistory();
});

final taxCalculateProvider =
    FutureProvider.family<TaxCalculationResult, TaxInput>((ref, input) async {
  final personalExpense = min(input.annualIncome * 0.5, 100000).toDouble();
  const personalDeduction = 60000.0;

  final result = TaxCalculator.calculate(
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

  return result;
});
