import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/mony_tokens.dart';
import '../../features/preferences/presentation/preferences_controller.dart';

class MonyNavigationShell extends ConsumerWidget {
  const MonyNavigationShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _selectBranch(int index) {
    // Reselecting the active destination preserves its route, filters and scroll.
    if (index == navigationShell.currentIndex) return;
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appPreferencesProvider).value;
    final visibleIndices = <int>[
      for (var index = 0; index < _labels.length; index++)
        if (preferences?.visibleNavigationModules.contains(_moduleIds[index]) ??
            true)
          index,
      if (preferences != null &&
          !preferences.visibleNavigationModules.contains(
            _moduleIds[navigationShell.currentIndex],
          ))
        navigationShell.currentIndex,
    ]..sort();
    final selectedVisibleIndex = visibleIndices.indexOf(
      navigationShell.currentIndex,
    );
    final activeIcons = [
      for (final index in visibleIndices) _activeIcons[index],
    ];
    final inactiveIcons = [
      for (final index in visibleIndices) _inactiveIcons[index],
    ];
    final destinations = [
      for (final index in visibleIndices) _railDestinations[index],
    ];
    final showLabels = preferences?.showNavigationLabels ?? false;
    final compactLabels = visibleIndices.length > 5;
    final wide = MediaQuery.sizeOf(context).width >= MonyBreakpoints.expanded;
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedVisibleIndex,
              onDestinationSelected: (index) =>
                  _selectBranch(visibleIndices[index]),
              labelType: NavigationRailLabelType.all,
              destinations: destinations,
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
          height: 82,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              height: 70,
              child: Stack(
                children: [
                  ExcludeSemantics(
                    child: CircleNavBar(
                      activeIndex: selectedVisibleIndex,
                      onTap: (index) => _selectBranch(visibleIndices[index]),
                      activeIcons: activeIcons,
                      inactiveIcons: inactiveIcons,
                      levels: showLabels
                          ? [
                              for (final index in visibleIndices)
                                compactLabels
                                    ? _compactLabels[index]
                                    : _labels[index],
                            ]
                          : null,
                      activeLevelsStyle: TextStyle(
                        fontSize:
                            12 * (preferences?.navigationLabelScale ?? 0.85),
                      ),
                      inactiveLevelsStyle: TextStyle(
                        fontSize:
                            12 * (preferences?.navigationLabelScale ?? 0.85),
                      ),
                      height: 70,
                      circleWidth: 56,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      circleColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      tabDurationMillSec: MonyMotion.durationFor(
                        context,
                        MonyMotion.standard,
                      ).inMilliseconds,
                      iconDurationMillSec: MonyMotion.durationFor(
                        context,
                        MonyMotion.quick,
                      ).inMilliseconds,
                      tabCurve: MonyMotion.curveFor(
                        context,
                        Curves.easeOutCubic,
                      ),
                      iconCurve: MonyMotion.curveFor(context, Curves.easeOut),
                      cornerRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                  Positioned.fill(
                    child: Row(
                      children: [
                        for (
                          var itemIndex = 0;
                          itemIndex < visibleIndices.length;
                          itemIndex++
                        )
                          Expanded(
                            child: Semantics(
                              key: ValueKey(
                                'main-nav-${_moduleIds[visibleIndices[itemIndex]]}',
                              ),
                              label: _labels[visibleIndices[itemIndex]],
                              button: true,
                              selected:
                                  navigationShell.currentIndex ==
                                  visibleIndices[itemIndex],
                              onTap: () =>
                                  _selectBranch(visibleIndices[itemIndex]),
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
        ),
      ),
    );
  }

  static const _labels = [
    'Inicio',
    'Fijos',
    'Recordatorios',
    'Ahorros',
    'Lista',
    'Estadísticas',
    'Plan de ciclo',
    'Historial',
  ];

  static const _moduleIds = [
    'home',
    'recurring',
    'obligations',
    'savings',
    'shoppingLists',
    'statistics',
    'cyclePlan',
    'transactions',
  ];

  static const _compactLabels = [
    'Inicio',
    'Fijos',
    'Avisos',
    'Ahorro',
    'Lista',
    'Stats',
    'Plan',
    'Hist.',
  ];

  static const _activeIcons = <Widget>[
    Icon(Icons.home, size: 26),
    Icon(Icons.repeat, size: 26),
    Icon(Icons.notifications_active, size: 26),
    Icon(Icons.savings, size: 26),
    Icon(Icons.shopping_cart, size: 26),
    Icon(Icons.query_stats, size: 26),
    Icon(Icons.account_balance_wallet, size: 26),
    Icon(Icons.receipt_long, size: 26),
  ];

  static const _inactiveIcons = <Widget>[
    Icon(Icons.home_outlined, size: 24),
    Icon(Icons.repeat_outlined, size: 24),
    Icon(Icons.notifications_outlined, size: 24),
    Icon(Icons.savings_outlined, size: 24),
    Icon(Icons.shopping_cart_outlined, size: 24),
    Icon(Icons.query_stats_outlined, size: 24),
    Icon(Icons.account_balance_wallet_outlined, size: 24),
    Icon(Icons.receipt_long_outlined, size: 24),
  ];

  static const _railDestinations = <NavigationRailDestination>[
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: Text('Inicio'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.repeat_outlined),
      selectedIcon: Icon(Icons.repeat),
      label: Text('Fijos'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.notifications_outlined),
      selectedIcon: Icon(Icons.notifications_active),
      label: Text('Recordatorios'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.savings_outlined),
      selectedIcon: Icon(Icons.savings),
      label: Text('Ahorros'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.shopping_cart_outlined),
      selectedIcon: Icon(Icons.shopping_cart),
      label: Text('Lista'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.query_stats_outlined),
      selectedIcon: Icon(Icons.query_stats),
      label: Text('Estadísticas'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_balance_wallet_outlined),
      selectedIcon: Icon(Icons.account_balance_wallet),
      label: Text('Plan de ciclo'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: Text('Historial'),
    ),
  ];
}
