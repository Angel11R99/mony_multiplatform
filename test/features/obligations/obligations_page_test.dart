import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mony_multiplatform/features/categories/domain/category.dart';
import 'package:mony_multiplatform/features/categories/presentation/categories_providers.dart';
import 'package:mony_multiplatform/features/obligations/domain/obligation.dart';
import 'package:mony_multiplatform/features/obligations/domain/obligation_repository.dart';
import 'package:mony_multiplatform/features/obligations/presentation/obligation_detail_page.dart';
import 'package:mony_multiplatform/features/obligations/presentation/obligations_page.dart';
import 'package:mony_multiplatform/features/obligations/presentation/obligations_providers.dart';
import 'package:mony_multiplatform/features/payment_methods/domain/payment_method.dart';
import 'package:mony_multiplatform/features/payment_methods/presentation/payment_methods_providers.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';
import 'package:mony_multiplatform/features/preferences/domain/preferences_repository.dart';
import 'package:mony_multiplatform/features/preferences/presentation/preferences_controller.dart';

class _MemoryPreferencesRepository implements PreferencesRepository {
  @override
  Future<AppPreferences> load() async => AppPreferences.defaults;

  @override
  Future<void> save(AppPreferences preferences) async {}
}

class _ObligationRepositoryFake implements ObligationRepository {
  final _updates = StreamController<List<Obligation>>.broadcast();
  final _obligations = <int, Obligation>{};
  var _nextId = 1;

  Future<void> dispose() => _updates.close();

  @override
  Stream<List<Obligation>> watchAll() => Stream.multi((sink) {
    sink.add(_obligations.values.toList(growable: false));
    final subscription = _updates.stream.listen(
      sink.add,
      onError: sink.addError,
    );
    sink.onCancel = subscription.cancel;
  });

  @override
  Stream<List<Obligation>> watchReminderCandidates() => watchAll().map(
    (items) => items
        .where(
          (item) =>
              !item.isCancelled &&
              item.dueDate != null &&
              item.remainingAmountInCents > 0,
        )
        .toList(growable: false),
  );

  @override
  Stream<List<Obligation>> watchList({
    required ObligationListFilter filter,
    DateTime? dueFrom,
    DateTime? dueThrough,
    required int limit,
  }) => watchAll().map((items) {
    final filtered = items.where((item) {
      final active = !item.isCancelled && item.remainingAmountInCents > 0;
      final matchesFilter = switch (filter) {
        ObligationListFilter.active => active,
        ObligationListFilter.payable =>
          active && item.direction == ObligationDirection.payable,
        ObligationListFilter.receivable =>
          active && item.direction == ObligationDirection.receivable,
        ObligationListFilter.history => !active,
      };
      final due = item.dueDate;
      final matchesDate =
          dueFrom == null ||
          (due != null &&
              !DateTime(
                due.year,
                due.month,
                due.day,
              ).isBefore(DateTime(dueFrom.year, dueFrom.month, dueFrom.day)) &&
              !DateTime(due.year, due.month, due.day).isAfter(
                DateTime(dueThrough!.year, dueThrough.month, dueThrough.day),
              ));
      return matchesFilter && matchesDate;
    }).toList();
    filtered.sort((a, b) {
      final dueA = a.dueDate;
      final dueB = b.dueDate;
      if (dueA == null && dueB != null) return 1;
      if (dueB == null && dueA != null) return -1;
      if (dueA != null && dueB != null) {
        final dueOrder = dueA.compareTo(dueB);
        if (dueOrder != 0) return dueOrder;
      }
      final updatedOrder = b.updatedAt.compareTo(a.updatedAt);
      return updatedOrder != 0 ? updatedOrder : a.id.compareTo(b.id);
    });
    return filtered.take(limit).toList(growable: false);
  });

  @override
  Stream<ObligationOverview> watchOverview() => watchAll().map((items) {
    final pending = items
        .where((item) => !item.isCancelled && item.remainingAmountInCents > 0)
        .toList();
    pending.sort((a, b) {
      final left = a.dueDate;
      final right = b.dueDate;
      if (left == null) return right == null ? 0 : 1;
      if (right == null) return -1;
      final byDueDate = left.compareTo(right);
      if (byDueDate != 0) return byDueDate;
      final byUpdatedAt = b.updatedAt.compareTo(a.updatedAt);
      return byUpdatedAt != 0 ? byUpdatedAt : a.id.compareTo(b.id);
    });
    return ObligationOverview(
      pending: pending.take(5).toList(growable: false),
      payableRemainingInCents: pending
          .where((item) => item.direction == ObligationDirection.payable)
          .fold(0, (total, item) => total + item.remainingAmountInCents),
      receivableRemainingInCents: pending
          .where((item) => item.direction == ObligationDirection.receivable)
          .fold(0, (total, item) => total + item.remainingAmountInCents),
    );
  });

  @override
  Future<List<Obligation>> getReminderCandidates() async => _obligations.values
      .where(
        (obligation) =>
            !obligation.isCancelled &&
            obligation.dueDate != null &&
            obligation.remainingAmountInCents > 0,
      )
      .toList(growable: false);

  @override
  Stream<ObligationDetails?> watchDetails(int obligationId) =>
      Stream.value(_details(obligationId));

  @override
  Future<ObligationDetails?> getDetails(int obligationId) async =>
      _details(obligationId);

  ObligationDetails? _details(int id) {
    final obligation = _obligations[id];
    return obligation == null
        ? null
        : ObligationDetails(obligation: obligation, payments: const []);
  }

  @override
  Future<int> create(Obligation obligation) async {
    final id = _nextId++;
    _obligations[id] = Obligation(
      id: id,
      direction: obligation.direction,
      title: obligation.title,
      counterparty: obligation.counterparty,
      amountInCents: obligation.amountInCents,
      dueDate: obligation.dueDate,
      categoryId: obligation.categoryId,
      defaultPaymentMethodId: obligation.defaultPaymentMethodId,
      notes: obligation.notes,
      createdAt: obligation.createdAt,
      updatedAt: obligation.updatedAt,
    );
    _updates.add(_obligations.values.toList(growable: false));
    return id;
  }

  @override
  Future<void> update(Obligation obligation) => throw UnimplementedError();

  @override
  Future<void> cancel(int obligationId) => throw UnimplementedError();

  @override
  Future<int> recordPayment({
    required int obligationId,
    required int amountInCents,
    required DateTime date,
    required int paymentMethodId,
    String? note,
  }) => throw UnimplementedError();

  @override
  Future<void> deletePayment(int paymentId) => throw UnimplementedError();
}

void main() {
  testWidgets('creates a payable and opens its obligation details', (
    tester,
  ) async {
    final repository = _ObligationRepositoryFake();
    final router = GoRouter(
      initialLocation: '/obligations',
      routes: [
        GoRoute(
          path: '/obligations',
          builder: (context, state) => const ObligationsPage(),
          routes: [
            GoRoute(
              path: ':id',
              name: 'obligationDetail',
              builder: (context, state) => ObligationDetailPage(
                obligationId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ],
        ),
      ],
    );
    final categories = [
      Category(
        id: 1,
        name: 'Salario',
        type: CategoryType.income,
        icon: 'payments',
        colorArgb: 0xFF16A34A,
        isActive: true,
        createdAt: DateTime(2026),
      ),
      Category(
        id: 6,
        name: 'Alimentación',
        type: CategoryType.expense,
        icon: 'restaurant',
        colorArgb: 0xFFEA580C,
        isActive: true,
        createdAt: DateTime(2026),
      ),
    ];
    final methods = [
      PaymentMethod(
        id: 1,
        name: 'Efectivo',
        icon: 'cash',
        colorArgb: 0xFF16A34A,
        isActive: true,
        isDefault: true,
        createdAt: DateTime(2026),
      ),
    ];
    addTearDown(() async {
      router.dispose();
      await repository.dispose();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          obligationRepositoryProvider.overrideWithValue(repository),
          categoriesProvider.overrideWith((ref) => Stream.value(categories)),
          activePaymentMethodsProvider.overrideWith(
            (ref) => Stream.value(methods),
          ),
          preferencesRepositoryProvider.overrideWithValue(
            _MemoryPreferencesRepository(),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nueva obligación'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Factura de luz');
    await tester.enterText(find.byType(TextField).at(1), 'Edesur');
    await tester.enterText(find.byType(TextField).at(2), '50.00');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Factura de luz'), findsOneWidget);
    expect(find.text('Sin abonos todavía'), findsOneWidget);
    expect(find.text('Edesur'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
