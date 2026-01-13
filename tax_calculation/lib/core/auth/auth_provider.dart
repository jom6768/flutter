import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/core/auth/auth_service.dart';
import 'package:tax_calculation/core/database/auth_database.dart';

final authDatabaseProvider = Provider<AuthDatabase>((ref) {
  return AuthDatabase();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(authDatabaseProvider));
});

final authUserProvider = StateProvider<User?>((ref) => null);
