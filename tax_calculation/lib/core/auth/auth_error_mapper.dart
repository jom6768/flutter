import 'package:tax_calculation/core/auth/auth_errors.dart';

typedef AuthErrorMatcher = bool Function(AuthError error);

class AuthErrorMapper {
  static final List<_Rule> _rules = [
    _Rule(
      matcher: (e) => e is UserNotFoundError || e is InvalidPasswordError,
      message: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
    ),
    _Rule(
      matcher: (e) => e is EmailAlreadyExistsError,
      message: 'อีเมลนี้ถูกใช้งานแล้ว',
    ),
  ];

  static String message(AuthError error) {
    for (final rule in _rules) {
      if (rule.matcher(error)) {
        return rule.message;
      }
    }
    return 'เกิดข้อผิดพลาด กรุณาลองใหม่';
  }
}

class _Rule {
  final AuthErrorMatcher matcher;
  final String message;

  const _Rule({
    required this.matcher,
    required this.message,
  });
}
