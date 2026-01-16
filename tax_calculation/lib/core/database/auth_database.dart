import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'auth_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Users])
class AuthDatabase extends _$AuthDatabase {
  AuthDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ---------- public queries ----------

  Future<User?> findUserByEmail(String email) {
    return (select(users)..where((u) => u.email.equals(email)))
        .getSingleOrNull();
  }

  Future<int> createUser(String email, String passwordHash) {
    return into(users).insert(
      UsersCompanion.insert(
        email: email,
        passwordHash: passwordHash,
      ),
    );
  }

  // ---------- init & seed ----------

  Future<void> init() async {
    if (kDebugMode) {
      await _seedDebugUserIfNeeded();
    }
  }

  Future<void> _seedDebugUserIfNeeded() async {
    const debugEmail = 'test@test.com';

    final exists = await findUserByEmail(debugEmail);
    if (exists != null) return;

    // password = 123456
    const debugPasswordHash =
        '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'; // sha256(123456)

    await into(users).insert(
      UsersCompanion.insert(
        email: debugEmail,
        passwordHash: debugPasswordHash,
      ),
    );
  }
}

// ---------- database connection ----------

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'auth.sqlite'));
    return NativeDatabase(file);
  });
}
