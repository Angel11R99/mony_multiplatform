import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:go_router/go_router.dart';

import '../theme/mony_tokens.dart';

class MonyNavigationShell extends StatelessWidget {
  const MonyNavigationShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _selectBranch(int index) {
    // Reselecting the active destination preserves its route, filters and scroll.
    if (index == navigationShell.currentIndex) return;
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= MonyBreakpoints.expanded;
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _selectBranch,
              labelType: NavigationRailLabelType.all,
              destinations: _railDestinations,
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Stack(
            children: [
              ExcludeSemantics(
                child: CircleNavBar(
                  activeIndex: navigationShell.currentIndex,
                  onTap: _selectBranch,
                  activeIcons: _activeIcons,
                  inactiveIcons: _inactiveIcons,
                  levels: _labels,
                  activeLevelsStyle: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  inactiveLevelsStyle: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  height: 70,
                  circleWidth: 56,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  circleColor: Theme.of(context).colorScheme.primaryContainer,
                  cornerRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    for (var index = 0; index < _labels.length; index++)
                      Expanded(
                        child: Semantics(
                          label: _labels[index],
                          button: true,
                          selected: navigationShell.currentIndex == index,
                          onTap: () => _selectBranch(index),
                          child: const ExcludeSemantics(
                            child: SizedBox.expand(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _labels = ['Inicio', 'Movimientos', 'Categorías', 'Métodos'];

  static const _activeIcons = <Widget>[
    Icon(Icons.home, size: 26),
    Icon(Icons.receipt_long, size: 26),
    Icon(Icons.category, size: 26),
    Icon(Icons.payment, size: 26),
  ];

  static const _inactiveIcons = <Widget>[
    Icon(Icons.home_outlined, size: 24),
    Icon(Icons.receipt_long_outlined, size: 24),
    Icon(Icons.category_outlined, size: 24),
    Icon(Icons.payment_outlined, size: 24),
  ];

  static const _railDestinations = <NavigationRailDestination>[
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: Text('Inicio'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: Text('Movimientos'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.category_outlined),
      selectedIcon: Icon(Icons.category),
      label: Text('Categorías'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.payment_outlined),
      selectedIcon: Icon(Icons.payment),
      label: Text('Métodos'),
    ),
  ];
}
