import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';
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
