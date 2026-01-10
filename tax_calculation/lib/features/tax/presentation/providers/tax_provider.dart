import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/core/database/tax_database.dart';
import 'package:tax_calculation/features/tax/data/tax_repository_impl.dart';
import 'package:tax_calculation/features/tax/data/tax_repository.dart';

final taxDatabaseProvider = Provider<TaxDatabase>((ref) {
  final db = TaxDatabase();

  // 🔴 Protect memory leak & ensure singleton
  ref.onDispose(() {
    db.close();
  });

  return db;
});

final taxRepositoryProvider = Provider<TaxRepository>((ref) {
  final db = ref.watch(taxDatabaseProvider);
  return TaxRepositoryImpl(db);
});
