import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'tax_database.g.dart';

class TaxRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get annualIncome => real()();
  RealColumn get personalExpense => real()();
  RealColumn get personalDeduction => real()();
  RealColumn get providentFund => real()();
  RealColumn get socialSecurity => real()();
  RealColumn get tax => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [TaxRecords])
class TaxDatabase extends _$TaxDatabase {
  TaxDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'tax.sqlite'));
    return NativeDatabase(file);
  });
}
