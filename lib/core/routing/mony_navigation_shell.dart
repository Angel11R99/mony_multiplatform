import 'package:flutter/material.dart';
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
    final destinations = [
      for (final index in visibleIndices) _railDestinations[index],
    ];
    final showLabels = preferences?.showNavigationLabels ?? false;
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
        child: Container(
          height: showLabels ? 68 : 56,
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              for (
                var itemIndex = 0;
                itemIndex < visibleIndices.length;
                itemIndex++
              )
                Expanded(
                  child: _NavigationItem(
                    key: ValueKey(
                      'main-nav-${_moduleIds[visibleIndices[itemIndex]]}',
                    ),
                    label: _labels[visibleIndices[itemIndex]],
                    compactLabel: _compactLabels[visibleIndices[itemIndex]],
                    icon: _inactiveIcons[visibleIndices[itemIndex]],
                    selectedIcon: _activeIcons[visibleIndices[itemIndex]],
                    selected: itemIndex == selectedVisibleIndex,
                    showLabel: showLabels,
                    compact: visibleIndices.length > 5,
                    labelScale: preferences?.navigationLabelScale ?? 0.85,
                    onTap: () => _selectBranch(visibleIndices[itemIndex]),
                  ),
                ),
            ],
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

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    super.key,
    required this.label,
    required this.compactLabel,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.showLabel,
    required this.compact,
    required this.labelScale,
    required this.onTap,
  });

  final String label;
  final String compactLabel;
  final Widget icon;
  final Widget selectedIcon;
  final bool selected;
  final bool showLabel;
  final bool compact;
  final double labelScale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final displayLabel = compact ? compactLabel : label;
    return Semantics(
      label: label,
      button: true,
      selected: selected,
      onTap: onTap,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ExcludeSemantics(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  width: 34,
                  height: 30,
                  decoration: BoxDecoration(
                    color: selected
                        ? colors.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      size: 21,
                      color: selected
                          ? colors.onPrimaryContainer
                          : colors.onSurfaceVariant,
                    ),
                    child: selected ? selectedIcon : icon,
                  ),
                ),
                if (showLabel) ...[
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        displayLabel,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 11.5 * labelScale,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected
                              ? colors.primary
                              : colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
