import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/categories/presentation/categories_page.dart';
import '../../features/payment_methods/presentation/payment_methods_page.dart';
import '../../features/transactions/presentation/transaction_detail_page.dart';
import '../../features/transactions/presentation/transaction_editor_page.dart';
import '../../features/transactions/presentation/transactions_page.dart';
import '../../features/preferences/presentation/settings_page.dart';

GoRouter createAppRouter({String initialLocation = '/'}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/categories',
      name: 'categories',
      builder: (context, state) => const CategoriesPage(),
    ),
    GoRoute(
      path: '/payment-methods',
      name: 'paymentMethods',
      builder: (context, state) => const PaymentMethodsPage(),
    ),
    GoRoute(
      path: '/transactions',
      name: 'transactions',
      builder: (context, state) => const TransactionsPage(),
      routes: [
        GoRoute(
          path: 'new',
          name: 'transactionNew',
          builder: (context, state) => const TransactionEditorPage(),
        ),
        GoRoute(
          path: ':id',
          name: 'transactionDetail',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '');
            return id == null
                ? UnknownRoutePage(location: state.uri.path)
                : TransactionDetailPage(transactionId: id);
          },
        ),
        GoRoute(
          path: ':id/edit',
          name: 'transactionEdit',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '');
            return id == null
                ? UnknownRoutePage(location: state.uri.path)
                : TransactionEditorPage(transactionId: id);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => UnknownRoutePage(location: state.uri.path),
);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Acerca de Mony')),
    body: Center(
      child: FilledButton.tonalIcon(
        onPressed: () => context.goNamed('home'),
        icon: const Icon(Icons.home_outlined),
        label: const Text('Volver al inicio'),
      ),
    ),
  );
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({required this.location, super.key});

  final String location;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Página no encontrada')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.route_outlined, size: 40),
          const SizedBox(height: 12),
          const Text('No encontramos esta pantalla.'),
          Text(location),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.goNamed('home'),
            child: const Text('Ir al inicio'),
          ),
        ],
      ),
    ),
  );
}
