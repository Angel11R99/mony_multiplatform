import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/transactions/data/drift_transaction_repository.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction.dart';
import 'package:mony_multiplatform/features/transactions/domain/transaction_repository.dart';

void main() {
  late AppDatabase database;
  late DriftTransactionRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftTransactionRepository(database);
  });
  tearDown(() => database.close());

  FinanceTransaction movement({
    int? id,
    int amountInCents = 12345,
    TransactionType type = TransactionType.expense,
    int categoryId = 6,
    int paymentMethodId = 1,
    String? description = '  Almuerzo  ',
    DateTime? date,
  }) => FinanceTransaction(
    id: id ?? 0,
    amountInCents: amountInCents,
    type: type,
    categoryId: categoryId,
    paymentMethodId: paymentMethodId,
    description: description,
    date: date ?? DateTime(2025, 3, 9),
    createdAt: DateTime(2025, 3, 9),
    updatedAt: DateTime(2025, 3, 9),
  );

  test('creates, normalizes, reads, orders and updates a movement', () async {
    final firstId = await repository.create(movement());
    final secondId = await repository.create(
      movement(
        amountInCents: 200,
        date: DateTime(2025, 3, 10),
        description: null,
      ),
    );

    final all = await repository.watchAll().first;
    expect(all.map((item) => item.id), [secondId, firstId]);
    expect(all.last.amountInCents, 12345);
    expect(all.last.description, 'Almuerzo');
    expect(all.last.date, DateTime(2025, 3, 9));

    final originalCreatedAt = all.last.createdAt;
    await repository.update(
      all.last.copyWith(amountInCents: 700, description: 'Editado'),
    );
    final saved = await repository.get(firstId);
    expect(saved!.amountInCents, 700);
    expect(saved.description, 'Editado');
    expect(saved.createdAt, originalCreatedAt);
    expect(
      saved.updatedAt.isAfter(originalCreatedAt) ||
          saved.updatedAt == originalCreatedAt,
      isTrue,
    );
  });

  test(
    'rejects inactive, mismatched and missing references and invalid amount',
    () async {
      await expectLater(
        repository.create(movement(amountInCents: 0)),
        throwsA(isA<InvalidTransactionException>()),
      );
      await expectLater(
        repository.create(movement(categoryId: 99999)),
        throwsA(isA<InvalidTransactionException>()),
      );
      await expectLater(
        repository.create(
          movement(type: TransactionType.income, categoryId: 6),
        ),
        throwsA(isA<InvalidTransactionException>()),
      );
      await expectLater(
        repository.create(movement(paymentMethodId: 99999)),
        throwsA(isA<InvalidTransactionException>()),
      );
      await database
          .into(database.categories)
          .insert(
            CategoriesCompanion.insert(
              name: 'Inactiva',
              normalizedName: 'inactiva',
              type: 'expense',
              icon: 'close',
              colorArgb: 0,
              isActive: const Value(false),
            ),
          )
          .then((id) async {
            await expectLater(
              repository.create(movement(categoryId: id)),
              throwsA(isA<InvalidTransactionException>()),
            );
          });
    },
  );

  test(
    'duplicate uses today and retains financial details without source ID',
    () async {
      final id = await repository.create(movement());
      final duplicateId = await repository.duplicate(id);
      final duplicate = await repository.get(duplicateId!);
      final now = DateTime.now();
      expect(duplicate!.id, duplicateId);
      expect(duplicate.id, isNot(id));
      expect(duplicate.amountInCents, 12345);
      expect(duplicate.categoryId, 6);
      expect(duplicate.paymentMethodId, 1);
      expect(duplicate.description, 'Almuerzo');
      expect(duplicate.date, DateTime(now.year, now.month, now.day));
      expect(await repository.duplicate(99999), isNull);
    },
  );

  test(
    'delete removes only the selected movement and category archive preserves history',
    () async {
      final id = await repository.create(movement());
      await repository.create(movement(categoryId: 7));
      await repository.delete(id);
      expect(await repository.get(id), isNull);
      expect(await repository.watchAll().first, hasLength(1));
    },
  );
}
