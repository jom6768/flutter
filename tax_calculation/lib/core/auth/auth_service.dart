import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:tax_calculation/core/auth/auth_errors.dart';
import 'package:tax_calculation/core/database/auth_database.dart';

class AuthService {
  final AuthDatabase db;

  AuthService(this.db);

  String _hash(String input) => sha256.convert(utf8.encode(input)).toString();

  // ---------- LOGIN ----------
  Future<User> signIn(String email, String password) async {
    try {
      final user = await db.findUserByEmail(email);

      if (user == null) {
        throw UserNotFoundError();
      }

      final hash = _hash(password);
      if (user.passwordHash != hash) {
        throw InvalidPasswordError();
      }

      return user;
    } on AuthError {
      // ส่ง AuthError เดิมขึ้นไปให้ UI
      rethrow;
    } catch (_) {
      // error อื่น ๆ (db crash, parsing, etc.)
      throw UnknownAuthError();
    }
  }

  // ---------- REGISTER ----------
  Future<User> register(String email, String password) async {
    try {
      final exists = await db.findUserByEmail(email);

      if (exists != null) {
        throw EmailAlreadyExistsError();
      }

      final hash = _hash(password);
      final id = await db.createUser(email, hash);

      return User(
        id: id,
        email: email,
        passwordHash: hash,
        createdAt: DateTime.now(),
      );
    } on AuthError {
      rethrow;
    } catch (_) {
      throw UnknownAuthError();
    }
  }
}
