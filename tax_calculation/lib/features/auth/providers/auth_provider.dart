import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/core/auth/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StateProvider<bool>((ref) {
  return false;
});
