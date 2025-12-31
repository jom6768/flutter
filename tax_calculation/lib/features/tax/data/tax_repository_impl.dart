import 'package:drift/drift.dart';

import '../../../../core/database/tax_database.dart';
import '../domain/models/tax_history.dart';
import 'tax_repository.dart';

class TaxRepositoryImpl implements TaxRepository {
  final TaxDatabase db;

  TaxRepositoryImpl(this.db);

  @override
  Future<void> save(TaxHistory history) async {
    final record = TaxRecordsCompanion(
      annualIncome: Value(history.annualIncome),
      personalExpense: Value(history.personalExpense),
      personalDeduction: Value(history.personalDeduction),
      providentFund: Value(history.providentFund),
      socialSecurity: Value(history.socialSecurity),
      tax: Value(history.tax),
    );

    await db.into(db.taxRecords).insert(record);
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
                (row) => TaxHistory(
                  annualIncome: row.annualIncome,
                  personalExpense: row.personalExpense,
                  personalDeduction: row.personalDeduction,
                  providentFund: row.providentFund,
                  socialSecurity: row.socialSecurity,
                  tax: row.tax,
                ),
              )
              .toList(),
        );
  }
}
