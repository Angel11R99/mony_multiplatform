import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';

/// In-memory database that avoids Drift's delayed stream-cache timers in tests.
AppDatabase createTestDatabase() => AppDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);
