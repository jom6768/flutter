import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/core/auth/auth_service.dart';
import 'package:tax_calculation/core/database/auth_database.dart';

final authDatabaseProvider = FutureProvider<AuthDatabase>((ref) async {
  final db = AuthDatabase();
  await db.init();
  return db;
});

final authServiceProvider = Provider<AuthService>((ref) {
  final db = ref.watch(authDatabaseProvider).requireValue;
  return AuthService(db);
});

final authUserProvider = StateProvider<User?>((ref) => null);
