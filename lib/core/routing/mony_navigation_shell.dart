import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nav_bar/nav_bar.dart';

import '../../features/preferences/presentation/preferences_controller.dart';
import '../theme/mony_tokens.dart';

class MonyNavigationShell extends ConsumerWidget {
  const MonyNavigationShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _selectBranch(int index) {
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
    final destinations = [
      for (final index in visibleIndices) _railDestinations[index],
    ];
    final wide = MediaQuery.sizeOf(context).width >= MonyBreakpoints.expanded;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = scheme.primary;

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
              color: scheme.outlineVariant,
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    final items = <NavBarItem>[
      for (final index in visibleIndices)
        NavBarItem(
          customIcon: Icon(_iconData[index], color: scheme.onSurfaceVariant),
          label: _labels[index],
        ),
    ];

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            FuturisticNavBar(
              selectedIndex: selectedVisibleIndex,
              onItemSelected: (index) => _selectBranch(visibleIndices[index]),
              items: items,
              style: NavBarStyle.floating,
              animationDuration: MonyMotion.standard,
              iconAnimationType: IconAnimationType.scale,
              iconSize: 25,
              showGlow: false,
              showLiquid: false,
              theme: FuturisticTheme(
                name: 'Mony',
                glowGradient: LinearGradient(colors: [accent, accent]),
                accentColor: accent,
                baseColor: scheme.surfaceContainer,
                particleColor: accent,
                backgroundColor: Colors.transparent,
                customColors: {
                  'baseColor': scheme.surfaceContainer,
                  'glowColor': accent,
                  'borderColor': scheme.outlineVariant,
                  'shadowColor': Colors.black,
                  'indicatorColor': accent.withValues(alpha: 0.2),
                  'indicatorHighlightColor': accent,
                },
                effectToggles: const {
                  'showShadow': false,
                  'showGlow': false,
                  'showBorder': true,
                  'showIndicator': true,
                },
              ),
              textStyle: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurface,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              barBackgroundColor: scheme.surface,
              barElevation: 0,
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 0,
              bottom: 20,
              child: Row(
                children: [
                  for (
                    var position = 0;
                    position < visibleIndices.length;
                    position++
                  )
                    Expanded(
                      child: Semantics(
                        key: ValueKey(
                          'main-nav-${_moduleIds[visibleIndices[position]]}',
                        ),
                        label: _labels[visibleIndices[position]],
                        button: true,
                        selected: position == selectedVisibleIndex,
                        onTap: () => _selectBranch(visibleIndices[position]),
                        child: const SizedBox.expand(),
                      ),
                    ),
                ],
              ),
            ),
          ],
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

  static const _iconData = <IconData>[
    Icons.home,
    Icons.repeat,
    Icons.notifications_active,
    Icons.savings,
    Icons.shopping_cart,
    Icons.query_stats,
    Icons.account_balance_wallet,
    Icons.receipt_long,
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
