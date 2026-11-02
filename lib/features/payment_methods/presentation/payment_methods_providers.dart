import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../data/drift_payment_methods_repository.dart';
import '../domain/payment_method.dart';
import '../domain/payment_methods_repository.dart';

final paymentMethodsRepositoryProvider = Provider<PaymentMethodsRepository>(
  (ref) => DriftPaymentMethodsRepository(ref.watch(appDatabaseProvider)),
);

final paymentMethodsProvider = StreamProvider<List<PaymentMethod>>(
  (ref) => ref.watch(paymentMethodsRepositoryProvider).watchAll(),
);

final activePaymentMethodsProvider = StreamProvider<List<PaymentMethod>>(
  (ref) => ref.watch(paymentMethodsRepositoryProvider).watchActive(),
);

final defaultPaymentMethodProvider = StreamProvider<PaymentMethod?>(
  (ref) => ref.watch(paymentMethodsRepositoryProvider).watchDefault(),
);
