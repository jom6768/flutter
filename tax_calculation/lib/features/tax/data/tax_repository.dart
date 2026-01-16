import 'package:drift/drift.dart';

import 'package:tax_calculation/core/database/tax_database.dart';
import 'package:tax_calculation/features/tax/domain/tax_models.dart';

abstract class TaxRepository {
  Future<int> insert(TaxHistory history);
  Future<void> update(TaxHistory history);
  Stream<List<TaxHistory>> watchHistory();
}

class TaxRepositoryImpl implements TaxRepository {
  final TaxDatabase db;

  TaxRepositoryImpl(this.db);

  @override
  Future<int> insert(TaxHistory h) {
    return db.into(db.taxRecords).insert(
          TaxRecordsCompanion(
            annualIncome: Value(h.annualIncome),
            personalExpense: Value(h.personalExpense),
            personalDeduction: Value(h.personalDeduction),
            providentFund: Value(h.providentFund),
            socialSecurity: Value(h.socialSecurity),
            lifeInsurance: Value(h.lifeInsurance),
            healthInsurance: Value(h.healthInsurance),
            doubleDonation: Value(h.doubleDonation),
            normalDonation: Value(h.normalDonation),
            tax: Value(h.tax),
          ),
        );
  }

  @override
  Future<void> update(TaxHistory h) {
    return (db.update(db.taxRecords)..where((t) => t.id.equals(h.id!))).write(
      TaxRecordsCompanion(
        annualIncome: Value(h.annualIncome),
        personalExpense: Value(h.personalExpense),
        personalDeduction: Value(h.personalDeduction),
        providentFund: Value(h.providentFund),
        socialSecurity: Value(h.socialSecurity),
        lifeInsurance: Value(h.lifeInsurance),
        healthInsurance: Value(h.healthInsurance),
        doubleDonation: Value(h.doubleDonation),
        normalDonation: Value(h.normalDonation),
        tax: Value(h.tax),
      ),
    );
  }

  @override
  Stream<List<TaxHistory>> watchHistory() {
    return (db.select(db.taxRecords)
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => TaxHistory(
                  id: r.id,
                  annualIncome: r.annualIncome,
                  personalExpense: r.personalExpense,
                  personalDeduction: r.personalDeduction,
                  providentFund: r.providentFund,
                  socialSecurity: r.socialSecurity,
                  lifeInsurance: r.lifeInsurance,
                  healthInsurance: r.healthInsurance,
                  doubleDonation: r.doubleDonation,
                  normalDonation: r.normalDonation,
                  tax: r.tax,
                ),
              )
              .toList(),
        );
  }
}
