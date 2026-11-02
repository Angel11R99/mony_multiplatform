import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/database/app_database.dart';
import 'package:mony_multiplatform/features/payment_methods/data/drift_payment_methods_repository.dart';
import 'package:mony_multiplatform/features/payment_methods/domain/payment_methods_repository.dart';

void main() {
  late AppDatabase database;
  late DriftPaymentMethodsRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftPaymentMethodsRepository(database);
  });
  tearDown(() async => database.close());

  test(
    'seeds cash, debit and credit with cash as the single default',
    () async {
      final methods = await repository.watchAll().first;
      expect(methods.map((method) => method.name), [
        'Efectivo',
        'Crédito',
        'Débito',
      ]);
      expect(methods.where((method) => method.isDefault), hasLength(1));
      expect(methods.first.isDefault, isTrue);
      expect(await repository.watchDefault().first, isNotNull);
    },
  );

  test('creates and edits methods while preserving their stable IDs', () async {
    await repository.create(
      name: 'Transferencia',
      icon: 'bank_transfer',
      colorArgb: 0xFF0891B2,
    );
    final created = (await repository.watchAll().first).singleWhere(
      (method) => method.name == 'Transferencia',
    );
    expect(created.isDefault, isFalse);
    expect(created.isActive, isTrue);

    await repository.update(
      id: created.id,
      name: 'Transferencia bancaria',
      icon: 'bank_transfer',
      colorArgb: 0xFF3B82F6,
    );
    final updated = (await repository.watchAll().first).singleWhere(
      (method) => method.id == created.id,
    );
    expect(updated.name, 'Transferencia bancaria');
    expect(updated.colorArgb, 0xFF3B82F6);
  });

  test('changing the default leaves exactly one active default', () async {
    final debit = (await repository.watchAll().first).singleWhere(
      (method) => method.name == 'Débito',
    );
    await repository.setDefault(debit.id);

    final methods = await repository.watchAll().first;
    expect(methods.where((method) => method.isDefault), hasLength(1));
    expect(methods.singleWhere((method) => method.isDefault).id, debit.id);
    expect((await repository.watchDefault().first)?.id, debit.id);
  });

  test('archiving the default promotes another and preserves its ID', () async {
    final cash = (await repository.watchAll().first).singleWhere(
      (method) => method.name == 'Efectivo',
    );
    await repository.setActive(cash.id, false);

    final archived = (await repository.watchAll().first).singleWhere(
      (method) => method.id == cash.id,
    );
    final active = await repository.watchActive().first;
    expect(archived.isActive, isFalse);
    expect(archived.isDefault, isFalse);
    expect(active.where((method) => method.isDefault), hasLength(1));
    expect((await repository.watchDefault().first)?.isActive, isTrue);

    await repository.setActive(cash.id, true);
    expect(
      (await repository.watchAll().first)
          .singleWhere((method) => method.id == cash.id)
          .isActive,
      isTrue,
    );
  });

  test('prevents archiving the last active method', () async {
    final cash = (await repository.watchAll().first).singleWhere(
      (method) => method.name == 'Efectivo',
    );
    final debit = (await repository.watchAll().first).singleWhere(
      (method) => method.name == 'Débito',
    );
    final credit = (await repository.watchAll().first).singleWhere(
      (method) => method.name == 'Crédito',
    );
    await repository.setActive(debit.id, false);
    await repository.setActive(credit.id, false);

    await expectLater(
      repository.setActive(cash.id, false),
      throwsA(isA<LastActivePaymentMethodException>()),
    );
    expect(await repository.watchActive().first, hasLength(1));
    expect((await repository.watchDefault().first)?.id, cash.id);
  });

  test(
    'rejects duplicate normalized names and keeps default selection active',
    () async {
      await expectLater(
        repository.create(
          name: ' EFECTIVO ',
          icon: 'wallet',
          colorArgb: 0xFF7C3AED,
        ),
        throwsA(anything),
      );
      final debit = (await repository.watchAll().first).singleWhere(
        (method) => method.name == 'Débito',
      );
      await repository.setActive(debit.id, false);
      await expectLater(
        repository.setDefault(debit.id),
        throwsA(isA<PaymentMethodUnavailableException>()),
      );
    },
  );

  test(
    'database index prevents storing more than one default method',
    () async {
      await expectLater(
        database
            .into(database.paymentMethods)
            .insert(
              PaymentMethodsCompanion.insert(
                name: 'Wallet',
                normalizedName: 'wallet',
                icon: 'wallet',
                colorArgb: 0xFF7C3AED,
                isDefault: const Value(true),
              ),
            ),
        throwsA(anything),
      );
    },
  );
}
