import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tax_calculation/features/auth/presentation/login_screen.dart';
import 'package:tax_calculation/core/auth/auth_provider.dart';
import 'package:tax_calculation/features/tax/presentation/screens/tax_form_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider);

    return user == null ? const LoginScreen() : const TaxFormScreen();
  }
}
