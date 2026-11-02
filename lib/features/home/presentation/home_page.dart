import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Mony'),
      actions: [
        IconButton(
          tooltip: 'Métodos de pago',
          onPressed: () => context.goNamed('paymentMethods'),
          icon: const Icon(Icons.payment_outlined),
        ),
        IconButton(
          tooltip: 'Administrar categorías',
          onPressed: () => context.goNamed('categories'),
          icon: const Icon(Icons.category_outlined),
        ),
        IconButton(
          tooltip: 'Apariencia y preferencias',
          onPressed: () => context.goNamed('settings'),
          icon: const Icon(Icons.tune),
        ),
        IconButton(
          tooltip: 'Acerca de Mony',
          onPressed: () => context.goNamed('about'),
          icon: const Icon(Icons.info_outline),
        ),
      ],
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Tus finanzas, en un solo lugar',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'La base de Mony está lista. Aquí comenzará tu resumen financiero.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed: () => context.goNamed('transactions'),
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Ver movimientos'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () => context.goNamed('paymentMethods'),
              icon: const Icon(Icons.payment_outlined),
              label: const Text('Métodos de pago'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () => context.goNamed('categories'),
              icon: const Icon(Icons.category_outlined),
              label: const Text('Administrar categorías'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.goNamed('about'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Explorar la app'),
            ),
          ],
        ),
      ),
    ),
  );
}
