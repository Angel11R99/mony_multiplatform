import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MonySettingsAction extends StatelessWidget {
  const MonySettingsAction({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Ajustes',
    constraints: const BoxConstraints.tightFor(width: 48, height: 48),
    padding: EdgeInsets.zero,
    iconSize: 24,
    onPressed: () => context.pushNamed('settings'),
    icon: const Icon(Icons.settings_outlined),
  );
}
