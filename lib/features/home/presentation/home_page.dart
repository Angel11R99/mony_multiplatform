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
