import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/core/database/encrypted_database_backup.dart';

void main() {
  late AppDatabase database;
  late EncryptedDatabaseBackup backup;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    backup = EncryptedDatabaseBackup(database);
  });

  tearDown(() => database.close());

  test('encrypts a complete database backup and restores all tables', () async {
    final original = await database.select(database.categories).get();
    expect(original, hasLength(21));
    final expenseCategory = original.firstWhere(
      (item) => item.type == 'expense',
    );
    final paymentMethod =
        (await database.select(database.paymentMethods).get()).first;
    await database
        .into(database.transactions)
        .insert(
          TransactionsCompanion.insert(
            amountInCents: 1585,
            type: 'expense',
            categoryId: expenseCategory.id,
            paymentMethodId: paymentMethod.id,
            description: const Value('Mercado de prueba'),
            dateEpochDay: DateTime.now().difference(DateTime(1970)).inDays,
          ),
        );
    final originalTransactions = await database
        .select(database.transactions)
        .get();
    final encrypted = await backup.create('a secure backup phrase');
    expect(utf8.decode(encrypted), contains('mony.encrypted-backup'));
    expect(utf8.decode(encrypted), isNot(contains('Salario')));

    await (database.update(
      database.categories,
    )..where((row) => row.id.equals(original.first.id))).write(
      const CategoriesCompanion(
        name: Value('Changed'),
        normalizedName: Value('changed'),
      ),
    );
    expect(
      (await database.select(database.categories).get()).first.name,
      'Changed',
    );

    await backup.restore(encrypted, 'a secure backup phrase');
    final restored = await database.select(database.categories).get();
    expect(restored, original);
    expect(
      await database.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
    expect(
      await database.select(database.transactions).get(),
      originalTransactions,
    );
  });

  test(
    'rejects wrong passphrases and tampering without changing local data',
    () async {
      final encrypted = await backup.create('another secure phrase');
      await (database.update(
        database.categories,
      )..where((row) => row.id.equals(1))).write(
        const CategoriesCompanion(
          name: Value('Keep this'),
          normalizedName: Value('keep this'),
        ),
      );

      await expectLater(
        backup.restore(encrypted, 'a different secure phrase'),
        throwsA(isA<DatabaseBackupException>()),
      );
      expect(
        (await database.select(database.categories).get()).first.name,
        'Keep this',
      );

      final tampered = Uint8List.fromList(encrypted)
        ..[encrypted.length - 3] ^= 1;
      await expectLater(
        backup.restore(tampered, 'another secure phrase'),
        throwsA(isA<DatabaseBackupException>()),
      );
      expect(
        (await database.select(database.categories).get()).first.name,
        'Keep this',
      );
    },
  );

  test('backs up and restores rows across a read batch boundary', () async {
    final categories = await database.select(database.categories).get();
    final expenseCategory = categories.firstWhere(
      (item) => item.type == 'expense',
    );
    final paymentMethod =
        (await database.select(database.paymentMethods).get()).first;
    final rows = [
      for (var index = 0; index < 501; index++)
        TransactionsCompanion.insert(
          amountInCents: index + 1,
          type: 'expense',
          categoryId: expenseCategory.id,
          paymentMethodId: paymentMethod.id,
          description: Value('Batch row $index'),
          dateEpochDay: 20000 + index,
        ),
    ];
    await database.batch(
      (batch) => batch.insertAll(database.transactions, rows),
    );

    final encrypted = await backup.create('batch backup passphrase');
    await database.delete(database.transactions).go();
    await backup.restore(encrypted, 'batch backup passphrase');

    expect(await database.select(database.transactions).get(), hasLength(501));
  });

  test('requires a strong passphrase before creating or restoring', () async {
    await expectLater(
      backup.create('short'),
      throwsA(isA<DatabaseBackupException>()),
    );
    await expectLater(
      backup.restore(Uint8List(1), 'short'),
      throwsA(isA<DatabaseBackupException>()),
    );
  });
}
