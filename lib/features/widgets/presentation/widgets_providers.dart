import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../budgets/presentation/budgets_providers.dart';
import '../../categories/presentation/categories_providers.dart';
import '../../obligations/presentation/obligations_providers.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../../recurring/presentation/recurring_providers.dart';
import '../../savings/presentation/savings_providers.dart';
import '../../transactions/presentation/transactions_providers.dart';
import '../domain/finance_widget_snapshot.dart';

const widgetAppGroupId = 'group.com.example.monyMultiplatform.widgets';
const financeWidgetSnapshotKey = 'finance_widget_snapshot_v1';

enum FinanceWidgetKind {
  finance(
    'FinanceWidget',
    'FinanceWidgetReceiver',
    'Balance y registro rápido',
    'Disponible en el ciclo y botones para registrar ingresos o gastos.',
  ),
  incomeExpense(
    'IncomeExpenseWidget',
    'IncomeExpenseWidgetReceiver',
    'Ingresos vs gastos',
    'Compara los ingresos y gastos del ciclo actual.',
  ),
  budgetProgress(
    'BudgetProgressWidget',
    'BudgetProgressWidgetReceiver',
    'Uso del presupuesto',
    'Muestra cuánto presupuesto se ha utilizado y los días restantes.',
  ),
  statistics(
    'StatisticsWidget',
    'StatisticsWidgetReceiver',
    'Estadísticas',
    'Resume gastos, balance y variación frente al ciclo anterior.',
  ),
  recentMovements(
    'RecentMovementsWidget',
    'RecentMovementsWidgetReceiver',
    'Movimientos recientes',
    'Consulta los últimos ingresos y gastos.',
  ),
  pendingReminders(
    'PendingRemindersWidget',
    'PendingRemindersWidgetReceiver',
    'Pagos y cobros pendientes',
    'Muestra próximos compromisos, atrasos y saldos pendientes.',
  ),
  savingsGoals(
    'SavingsGoalsWidget',
    'SavingsGoalsWidgetReceiver',
    'Metas de ahorro',
    'Sigue el avance de tus metas activas.',
  ),
  fixedCommitments(
    'FixedCommitmentsWidget',
    'FixedCommitmentsWidgetReceiver',
    'Compromisos fijos',
    'Consulta las entradas recurrentes y sus próximos vencimientos.',
  ),
  quickAccess(
    'QuickAccessWidget',
    'QuickAccessWidgetReceiver',
    'Accesos rápidos',
    'Abre directamente el registro de ingreso o gasto.',
  ),
  dailySpending(
    'DailySpendingWidget',
    'DailySpendingWidgetReceiver',
    'Gasto de hoy',
    'Revisa lo gastado hoy y el ritmo diario disponible.',
  ),
  categoryLimits(
    'CategoryLimitsWidget',
    'CategoryLimitsWidgetReceiver',
    'Límites por categoría',
    'Prioriza las categorías que se acercan o exceden su límite.',
  );

  const FinanceWidgetKind(
    this.iOSKind,
    this.androidReceiver,
    this.label,
    this.description,
  );

  final String iOSKind;
  final String androidReceiver;
  final String label;
  final String description;

  String get qualifiedAndroidReceiver =>
      'com.example.mony_multiplatform.widgets.$androidReceiver';
}

final financeWidgetSnapshotProvider =
    Provider<AsyncValue<FinanceWidgetSnapshot>>((ref) {
      final transactions = ref.watch(transactionsProvider);
      final budget = ref.watch(budgetConfigProvider);
      final categories = ref.watch(categoriesProvider);
      final obligations = ref.watch(obligationsProvider);
      final goals = ref.watch(savingsGoalsProvider);
      final recurring = ref.watch(recurringEntriesProvider);
      final preferences = ref.watch(appPreferencesProvider);

      final errors = [
        transactions.asError,
        budget.asError,
        categories.asError,
        obligations.asError,
        goals.asError,
        recurring.asError,
        preferences.asError,
      ].whereType<AsyncError<Object?>>();
      final error = errors.isEmpty ? null : errors.first;
      if (error != null) {
        return AsyncError<FinanceWidgetSnapshot>(error.error, error.stackTrace);
      }

      final transactionItems = transactions.asData?.value;
      final budgetConfig = budget.asData?.value;
      final categoryItems = categories.asData?.value;
      final obligationItems = obligations.asData?.value;
      final goalItems = goals.asData?.value;
      final recurringItems = recurring.asData?.value;
      final preferenceItems = preferences.asData?.value;
      if (transactionItems == null ||
          budget.asData == null ||
          categoryItems == null ||
          obligationItems == null ||
          goalItems == null ||
          recurringItems == null ||
          preferenceItems == null) {
        return const AsyncLoading<FinanceWidgetSnapshot>();
      }

      return AsyncData(
        FinanceWidgetSnapshot.fromData(
          now: DateTime.now(),
          transactions: transactionItems,
          budget: budgetConfig,
          categories: categoryItems,
          obligations: obligationItems,
          savingsGoals: goalItems,
          recurringEntries: recurringItems,
          preferences: preferenceItems,
        ),
      );
    });

class FinanceWidgetPublisher {
  Future<void>? _setup;

  Future<void> publish(FinanceWidgetSnapshot snapshot) async {
    if (kIsWeb ||
        !const {TargetPlatform.android, TargetPlatform.iOS}.contains(
          defaultTargetPlatform,
        )) {
      return;
    }
    await (_setup ??= _configurePlatform());
    await HomeWidget.saveWidgetData<String>(
      financeWidgetSnapshotKey,
      _encodeSnapshot(snapshot),
    );
    await Future.wait(
      FinanceWidgetKind.values.map(
        (kind) => HomeWidget.updateWidget(
          androidName: kind.qualifiedAndroidReceiver,
          iOSName: kind.iOSKind,
        ),
      ),
    );
  }

  Future<void> _configurePlatform() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await HomeWidget.setAppGroupId(widgetAppGroupId);
    }
  }
}

String _encodeSnapshot(FinanceWidgetSnapshot snapshot) {
  // The serialized cache is a read-only presentation snapshot; Drift remains
  // the only source of financial truth.
  return const JsonEncoder().convert(snapshot.toJson());
}
