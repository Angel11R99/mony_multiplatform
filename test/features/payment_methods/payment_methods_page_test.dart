import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/routing/app_router.dart';
import 'package:mony_multiplatform/features/payment_methods/domain/payment_method.dart';
import 'package:mony_multiplatform/features/payment_methods/domain/payment_methods_repository.dart';
import 'package:mony_multiplatform/features/payment_methods/presentation/payment_method_picker.dart';
import 'package:mony_multiplatform/features/payment_methods/presentation/payment_methods_page.dart';
import 'package:mony_multiplatform/features/payment_methods/presentation/payment_methods_providers.dart';

void main() {
  late _FakePaymentMethodsRepository repository;

  setUp(() => repository = _FakePaymentMethodsRepository());
  tearDown(() async => repository.dispose());

  Future<void> openPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paymentMethodsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: PaymentMethodsPage()),
      ),
    );
    await tester.pumpAndSettle();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }

  testWidgets('shows the default and updates it from the method actions', (
    tester,
  ) async {
    await openPage(tester);
    expect(find.text('Efectivo'), findsOneWidget);
    expect(find.text('Predeterminado'), findsOneWidget);

    await tester.tap(find.byTooltip('Acciones para Débito'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hacer predeterminado'));
    await tester.pumpAndSettle();

    expect(
      repository.methods.singleWhere((item) => item.isDefault).name,
      'Débito',
    );
    expect(
      find.text('Débito ahora es el método predeterminado.'),
      findsOneWidget,
    );
  });

  testWidgets('creates a custom method and trims its name', (tester) async {
    await openPage(tester);
    await tester.tap(find.text('Nuevo método'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      '  Transferencia  ',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(
      repository.methods.any((item) => item.name == 'Transferencia'),
      isTrue,
    );
    expect(find.text('Método de pago creado.'), findsOneWidget);
  });

  testWidgets('opens payment methods from the home route', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paymentMethodsRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(routerConfig: createAppRouter()),
      ),
    );
    await tester.pumpAndSettle();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    await tester.tap(find.byTooltip('Métodos de pago'));
    await tester.pumpAndSettle();
    expect(find.text('Métodos de pago'), findsOneWidget);
    expect(find.text('Efectivo'), findsOneWidget);
  });

  testWidgets(
    'payment picker selects the default and returns a stable method',
    (tester) async {
      PaymentMethod? selected;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            paymentMethodsRepositoryProvider.overrideWithValue(repository),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Form(
                child: PaymentMethodPicker(
                  value: null,
                  onChanged: (method) => selected = method,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      });

      expect(find.text('· Predeterminado'), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Débito').last);
      await tester.pumpAndSettle();
      expect(selected?.id, 2);
    },
  );
}

class _FakePaymentMethodsRepository implements PaymentMethodsRepository {
  _FakePaymentMethodsRepository()
    : methods = [
        _method(1, 'Efectivo', 'cash', isDefault: true),
        _method(2, 'Débito', 'debit_card'),
        _method(3, 'Crédito', 'credit_card'),
      ];

  final List<PaymentMethod> methods;
  final StreamController<List<PaymentMethod>> _changes =
      StreamController<List<PaymentMethod>>.broadcast(sync: true);

  @override
  Stream<List<PaymentMethod>> watchAll() async* {
    yield List.unmodifiable(methods);
    yield* _changes.stream;
  }

  @override
  Stream<List<PaymentMethod>> watchActive() => watchAll().map(
    (items) => items.where((item) => item.isActive).toList(growable: false),
  );

  @override
  Stream<PaymentMethod?> watchDefault() => watchAll().map((items) {
    for (final item in items) {
      if (item.isDefault) return item;
    }
    return null;
  });

  @override
  Future<void> create({
    required String name,
    required String icon,
    required int colorArgb,
  }) async {
    methods.add(
      PaymentMethod(
        id: 4,
        name: name.trim(),
        icon: icon,
        colorArgb: colorArgb,
        isActive: true,
        isDefault: false,
        createdAt: DateTime(2026),
      ),
    );
    _emit();
  }

  @override
  Future<void> update({
    required int id,
    required String name,
    required String icon,
    required int colorArgb,
  }) async {
    final index = methods.indexWhere((item) => item.id == id);
    methods[index] = methods[index].copyWith(
      name: name.trim(),
      icon: icon,
      colorArgb: colorArgb,
    );
    _emit();
  }

  @override
  Future<void> setDefault(int id) async {
    final selected = methods.firstWhere((item) => item.id == id);
    if (!selected.isActive) throw const PaymentMethodUnavailableException();
    for (var index = 0; index < methods.length; index++) {
      methods[index] = methods[index].copyWith(
        isDefault: methods[index].id == id,
      );
    }
    _emit();
  }

  @override
  Future<void> setActive(int id, bool isActive) async {
    final selected = methods.firstWhere((item) => item.id == id);
    if (selected.isActive && !isActive) {
      if (methods.where((item) => item.isActive).length == 1) {
        throw const LastActivePaymentMethodException();
      }
      methods[methods.indexOf(selected)] = selected.copyWith(
        isActive: false,
        isDefault: false,
      );
      if (selected.isDefault) {
        final next = methods.firstWhere((item) => item.isActive);
        methods[methods.indexOf(next)] = next.copyWith(isDefault: true);
      }
    } else {
      methods[methods.indexOf(selected)] = selected.copyWith(
        isActive: isActive,
      );
    }
    _emit();
  }

  void _emit() => _changes.add(List.unmodifiable(methods));

  Future<void> dispose() => _changes.close();
}

PaymentMethod _method(
  int id,
  String name,
  String icon, {
  bool isDefault = false,
}) => PaymentMethod(
  id: id,
  name: name,
  icon: icon,
  colorArgb: 0xFF7C3AED,
  isActive: true,
  isDefault: isDefault,
  createdAt: DateTime(2026),
);
