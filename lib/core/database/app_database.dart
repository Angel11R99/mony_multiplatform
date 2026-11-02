import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/categories/data/categories_table.dart';
import '../../features/budgets/data/budgets_table.dart';
import '../../features/categories/domain/category.dart';
import '../../features/payment_methods/data/payment_methods_table.dart';
import '../../features/savings/data/savings_goals_table.dart';
import '../../features/shopping_lists/data/shopping_lists_table.dart';
import '../../features/obligations/data/obligations_table.dart';
import '../../features/recurring/data/recurring_entries_table.dart';
import '../../features/transactions/data/transactions_table.dart';
import 'app_database.steps.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    PaymentMethods,
    Transactions,
    SavingsGoals,
    Budgets,
    BudgetCycles,
    ShoppingLists,
    ShoppingListItems,
    ShoppingAdjustments,
    ShoppingPayables,
    Obligations,
    ObligationPayments,
    RecurringEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'mony',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await batch((batch) {
        batch.insertAll(
          categories,
          _initialCategories
              .map(
                (category) => CategoriesCompanion.insert(
                  name: category.$1,
                  normalizedName: category.$1.toLowerCase(),
                  type: category.$2.name,
                  icon: category.$3,
                  colorArgb: category.$4,
                ),
              )
              .toList(),
        );
      });
      await _seedPaymentMethods();
    },
    onUpgrade: stepByStep(
      from1To2: (migrator, schema) async {
        await migrator.createTable(schema.paymentMethods);
        await migrator.create(schema.paymentMethodsSingleDefault);
        await _seedPaymentMethods();
      },
      from2To3: (migrator, schema) async {
        await migrator.createTable(schema.transactions);
        await migrator.create(schema.transactionsDateIdx);
        await migrator.create(schema.transactionsCategoryIdx);
        await migrator.create(schema.transactionsPaymentMethodIdx);
        await migrator.create(schema.transactionsFixedEntryIdx);
        await migrator.create(schema.transactionsSavingsGoalIdx);
      },
      from3To4: (migrator, schema) async {
        await migrator.createTable(schema.savingsGoals);
        await migrator.create(schema.savingsGoalsCompletedIdx);
      },
      from4To5: (migrator, schema) async {
        await migrator.createTable(schema.budgets);
        await migrator.createTable(schema.budgetCycles);
        await migrator.create(schema.budgetCyclesStartEndIdx);
      },
      from5To6: (migrator, schema) async {
        await migrator.createTable(schema.shoppingLists);
        await migrator.create(schema.shoppingListsExpenseIdx);
        await migrator.createTable(schema.shoppingListItems);
        await migrator.create(schema.shoppingListItemsListIdx);
        await migrator.createTable(schema.shoppingAdjustments);
        await migrator.create(schema.shoppingAdjustmentsListIdx);
        await migrator.createTable(schema.shoppingPayables);
      },
      from6To7: (migrator, schema) async {
        await migrator.createTable(schema.obligations);
        await migrator.createTable(schema.obligationPayments);
        await migrator.create(schema.obligationPaymentsObligationIdx);
        await customStatement('''
          INSERT INTO obligations (
            id, direction, title, counterparty, amount_in_cents,
            due_date_epoch_day, category_id, default_payment_method_id,
            source_shopping_list_id, is_cancelled, notes, created_at, updated_at
          )
          SELECT id, 'payable', description, NULL, amount_in_cents,
            NULL, category_id, payment_method_id, shopping_list_id, 0, NULL,
            created_at, updated_at
          FROM shopping_payables
        ''');
        await customStatement('''
          INSERT INTO obligation_payments (
            obligation_id, amount_in_cents, date_epoch_day, payment_method_id,
            transaction_id, note, created_at
          )
          SELECT payables.id, payables.amount_in_cents, transactions.date_epoch_day,
            transactions.payment_method_id, transactions.id,
            'Liquidación anterior', payables.updated_at
          FROM shopping_payables AS payables
          INNER JOIN transactions ON transactions.id = payables.transaction_id
          WHERE payables.is_settled = 1
        ''');
      },
      from7To8: (migrator, schema) async {
        await migrator.createTable(schema.recurringEntries);
        await migrator.create(schema.recurringEntriesActiveNextIdx);
        await migrator.create(schema.transactionsRecurringDateUnique);
      },
      from8To9: (migrator, schema) async {
        await migrator.addColumn(
          schema.shoppingListItems,
          schema.shoppingListItems.barcode,
        );
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  @override
  int get schemaVersion => 9;
}

const _initialCategories = <(String, CategoryType, String, int)>[
  ('Salario', CategoryType.income, 'payments', 0xFF16A34A),
  ('Trabajo extra', CategoryType.income, 'work', 0xFF0891B2),
  ('Freelance', CategoryType.income, 'laptop', 0xFF3B82F6),
  ('Venta', CategoryType.income, 'sell', 0xFFD97706),
  ('Otros ingresos', CategoryType.income, 'add_circle', 0xFF71717A),
  ('Alimentación', CategoryType.expense, 'restaurant', 0xFFEA580C),
  ('Transporte', CategoryType.expense, 'directions_car', 0xFF3B82F6),
  ('Vivienda', CategoryType.expense, 'home', 0xFF9333EA),
  ('Servicios', CategoryType.expense, 'receipt_long', 0xFF0891B2),
  ('Internet', CategoryType.expense, 'wifi', 0xFF7C3AED),
  ('Teléfono', CategoryType.expense, 'phone_android', 0xFFEC4899),
  ('Salud', CategoryType.expense, 'medical_services', 0xFFEF4444),
  ('Educación', CategoryType.expense, 'school', 0xFF0D9488),
  ('Entretenimiento', CategoryType.expense, 'movie', 0xFF9333EA),
  ('Compras', CategoryType.expense, 'shopping_cart', 0xFFEC4899),
  ('Deudas', CategoryType.expense, 'credit_card', 0xFF71717A),
  ('Suscripciones', CategoryType.expense, 'subscriptions', 0xFF0891B2),
  ('Familia', CategoryType.expense, 'family_restroom', 0xFF16A34A),
  ('Ahorro', CategoryType.expense, 'savings', 0xFF16A34A),
  ('Emergencias', CategoryType.expense, 'emergency', 0xFFEF4444),
  ('Otros', CategoryType.expense, 'more_horiz', 0xFF71717A),
];

const _initialPaymentMethods = <(String, String, int, bool)>[
  ('Efectivo', 'cash', 0xFF16A34A, true),
  ('Débito', 'debit_card', 0xFF3B82F6, false),
  ('Crédito', 'credit_card', 0xFF9333EA, false),
];

extension on AppDatabase {
  Future<void> _seedPaymentMethods() async {
    await batch((batch) {
      batch.insertAll(
        paymentMethods,
        _initialPaymentMethods
            .map(
              (method) => PaymentMethodsCompanion.insert(
                name: method.$1,
                normalizedName: method.$1.toLowerCase(),
                icon: method.$2,
                colorArgb: method.$3,
                isDefault: Value(method.$4),
              ),
            )
            .toList(),
      );
    });
  }
}
