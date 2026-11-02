import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/payment_method.dart';
import '../domain/payment_methods_repository.dart';

class DriftPaymentMethodsRepository implements PaymentMethodsRepository {
  const DriftPaymentMethodsRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<PaymentMethod>> watchAll() =>
      (_database.select(_database.paymentMethods)..orderBy([
            (row) => OrderingTerm.desc(row.isDefault),
            (row) => OrderingTerm.desc(row.isActive),
            (row) => OrderingTerm.asc(row.name),
          ]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList(growable: false));

  @override
  Stream<List<PaymentMethod>> watchActive() =>
      (_database.select(_database.paymentMethods)
            ..where((row) => row.isActive.equals(true))
            ..orderBy([
              (row) => OrderingTerm.desc(row.isDefault),
              (row) => OrderingTerm.asc(row.name),
            ]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList(growable: false));

  @override
  Stream<PaymentMethod?> watchDefault() =>
      (_database.select(_database.paymentMethods)
            ..where((row) => row.isDefault.equals(true)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _fromRow(row));

  @override
  Future<void> create({
    required String name,
    required String icon,
    required int colorArgb,
  }) async {
    await _database.transaction(() async {
      final defaultMethod = await (_database.select(
        _database.paymentMethods,
      )..where((row) => row.isDefault.equals(true))).getSingleOrNull();
      await _database
          .into(_database.paymentMethods)
          .insert(
            PaymentMethodsCompanion.insert(
              name: name.trim(),
              normalizedName: name.trim().toLowerCase(),
              icon: icon,
              colorArgb: colorArgb,
              isDefault: Value(defaultMethod == null),
            ),
          );
    });
  }

  @override
  Future<void> update({
    required int id,
    required String name,
    required String icon,
    required int colorArgb,
  }) async {
    await (_database.update(
      _database.paymentMethods,
    )..where((row) => row.id.equals(id))).write(
      PaymentMethodsCompanion(
        name: Value(name.trim()),
        normalizedName: Value(name.trim().toLowerCase()),
        icon: Value(icon),
        colorArgb: Value(colorArgb),
      ),
    );
  }

  @override
  Future<void> setDefault(int id) => _database.transaction(() async {
    final selected = await (_database.select(
      _database.paymentMethods,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (selected == null || !selected.isActive) {
      throw const PaymentMethodUnavailableException();
    }
    await (_database.update(_database.paymentMethods)
          ..where((row) => row.isDefault.equals(true)))
        .write(const PaymentMethodsCompanion(isDefault: Value(false)));
    await (_database.update(_database.paymentMethods)
          ..where((row) => row.id.equals(id)))
        .write(const PaymentMethodsCompanion(isDefault: Value(true)));
  });

  @override
  Future<void> setActive(int id, bool isActive) =>
      _database.transaction(() async {
        final selected = await (_database.select(
          _database.paymentMethods,
        )..where((row) => row.id.equals(id))).getSingleOrNull();
        if (selected == null) throw const PaymentMethodUnavailableException();
        if (selected.isActive == isActive) return;

        if (!isActive) {
          final active = await (_database.select(
            _database.paymentMethods,
          )..where((row) => row.isActive.equals(true))).get();
          if (active.length <= 1) {
            throw const LastActivePaymentMethodException();
          }

          await (_database.update(
            _database.paymentMethods,
          )..where((row) => row.id.equals(id))).write(
            const PaymentMethodsCompanion(
              isActive: Value(false),
              isDefault: Value(false),
            ),
          );
          if (selected.isDefault) {
            final replacement =
                await (_database.select(_database.paymentMethods)
                      ..where((row) => row.isActive.equals(true))
                      ..orderBy([(row) => OrderingTerm.asc(row.name)])
                      ..limit(1))
                    .getSingleOrNull();
            if (replacement != null) {
              await (_database.update(_database.paymentMethods)
                    ..where((row) => row.id.equals(replacement.id)))
                  .write(const PaymentMethodsCompanion(isDefault: Value(true)));
            }
          }
        } else {
          await (_database.update(_database.paymentMethods)
                ..where((row) => row.id.equals(id)))
              .write(const PaymentMethodsCompanion(isActive: Value(true)));
        }
      });

  PaymentMethod _fromRow(PaymentMethodRow row) => PaymentMethod(
    id: row.id,
    name: row.name,
    icon: row.icon,
    colorArgb: row.colorArgb,
    isActive: row.isActive,
    isDefault: row.isDefault,
    createdAt: row.createdAt,
  );
}
