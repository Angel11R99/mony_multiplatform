import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';
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
    final compactLabels = visibleIndices.length > 5;
    final hasMoreNativeTabs = visibleIndices.length > 5;
    final nativeIndices = hasMoreNativeTabs
        ? visibleIndices.take(4).toList(growable: false)
        : visibleIndices;
    final nativeOverflowIndices = visibleIndices
        .where((index) => !nativeIndices.contains(index))
        .toList(growable: false);
    final nativeTabs = <NativeGlassNavBarItem>[
      for (final index in nativeIndices) _nativeTab(index),
      if (hasMoreNativeTabs)
        const NativeGlassNavBarItem(label: 'Más', symbol: 'ellipsis'),
    ];
    final nativeSelectedIndex = nativeIndices.indexOf(
      navigationShell.currentIndex,
    );
    final nativeCurrentIndex = nativeSelectedIndex >= 0
        ? nativeSelectedIndex
        : nativeTabs.length - 1;
    final wide = MediaQuery.sizeOf(context).width >= MonyBreakpoints.expanded;
    final theme = Theme.of(context);
    final highContrast = MediaQuery.highContrastOf(context);
    final dark = theme.brightness == Brightness.dark;
    final glassFill = highContrast
        ? theme.colorScheme.surfaceContainer
        : Colors.white.withValues(alpha: dark ? 0.2 : 0.48);
    final glassIndicator = Colors.white.withValues(alpha: dark ? 0.25 : 0.72);
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
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: NativeGlassNavBar(
        tabs: nativeTabs,
        currentIndex: nativeCurrentIndex,
        tintColor: theme.colorScheme.primary,
        onTap: (index) {
          if (hasMoreNativeTabs && index == nativeTabs.length - 1) {
            _showMore(context, nativeOverflowIndices);
            return;
          }
          _selectBranch(nativeIndices[index]);
        },
        fallback: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              MonySpace.x3,
              0,
              MonySpace.x3,
              MonySpace.x2,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: glassFill,
                    gradient: highContrast
                        ? null
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: dark ? 0.16 : 0.3),
                              Colors.white.withValues(
                                alpha: dark ? 0.06 : 0.12,
                              ),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: highContrast
                          ? theme.colorScheme.outline
                          : Colors.white.withValues(alpha: dark ? 0.42 : 0.78),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 18,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bubbleSize = math.min(
                        64.0,
                        constraints.maxWidth / visibleIndices.length + 6,
                      );
                      return SizedBox(
                        height: 82,
                        child: Row(
                          children: [
                            for (final index in visibleIndices)
                              Expanded(
                                child: _GlassNavigationItem(
                                  key: ValueKey(
                                    'main-nav-${_moduleIds[index]}',
                                  ),
                                  label: compactLabels
                                      ? _compactLabels[index]
                                      : _labels[index],
                                  selected:
                                      navigationShell.currentIndex == index,
                                  showLabel:
                                      navigationShell.currentIndex == index ||
                                      (showLabels && !compactLabels),
                                  activeIcon: _activeIcons[index],
                                  inactiveIcon: _inactiveIcons[index],
                                  bubbleSize: bubbleSize,
                                  labelScale:
                                      preferences?.navigationLabelScale ?? 0.85,
                                  accentColor: theme.colorScheme.primary,
                                  labelColor:
                                      theme.colorScheme.onSurfaceVariant,
                                  bubbleColor: glassIndicator,
                                  reducedMotion: MediaQuery.disableAnimationsOf(
                                    context,
                                  ),
                                  onTap: () => _selectBranch(index),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMore(BuildContext context, List<int> overflowIndices) {
    showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: MonySpace.x4),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                MonySpace.x4,
                MonySpace.x2,
                MonySpace.x4,
                MonySpace.x2,
              ),
              child: Text(
                'Más secciones',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final index in overflowIndices)
              ListTile(
                leading: _inactiveIcons[index],
                title: Text(_labels[index]),
                selected: index == navigationShell.currentIndex,
                onTap: () => Navigator.of(context).pop(index),
              ),
          ],
        ),
      ),
    ).then((index) {
      if (index != null) _selectBranch(index);
    });
  }

  static NativeGlassNavBarItem _nativeTab(int index) => NativeGlassNavBarItem(
    label: _labels[index],
    symbol: _nativeSymbols[index],
    selectedSymbol: _nativeSelectedSymbols[index],
  );

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

  static const _nativeSymbols = [
    'house',
    'repeat',
    'bell',
    'dollarsign.circle',
    'cart',
    'chart.bar',
    'calendar',
    'list.bullet.rectangle',
  ];

  static const _nativeSelectedSymbols = [
    'house.fill',
    'repeat',
    'bell.fill',
    'dollarsign.circle.fill',
    'cart.fill',
    'chart.bar.fill',
    'calendar',
    'list.bullet.rectangle.fill',
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

class _GlassNavigationItem extends StatelessWidget {
  const _GlassNavigationItem({
    required this.label,
    required this.selected,
    required this.showLabel,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.bubbleSize,
    required this.labelScale,
    required this.accentColor,
    required this.labelColor,
    required this.bubbleColor,
    required this.reducedMotion,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final bool showLabel;
  final Widget activeIcon;
  final Widget inactiveIcon;
  final double bubbleSize;
  final double labelScale;
  final Color accentColor;
  final Color labelColor;
  final Color bubbleColor;
  final bool reducedMotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconDiameter = selected ? bubbleSize : math.min(44.0, bubbleSize);
    return Semantics(
      label: label,
      button: true,
      selected: selected,
      onTap: onTap,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          excludeFromSemantics: true,
          borderRadius: BorderRadius.circular(32),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return accentColor.withValues(alpha: 0.14);
            }
            if (states.contains(WidgetState.pressed)) {
              return accentColor.withValues(alpha: 0.1);
            }
            return Colors.transparent;
          }),
          child: SizedBox(
            height: 82,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OverflowBox(
                  maxWidth: bubbleSize,
                  maxHeight: bubbleSize,
                  child: AnimatedContainer(
                    duration: reducedMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    width: iconDiameter,
                    height: iconDiameter,
                    decoration: selected
                        ? BoxDecoration(
                            color: bubbleColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.22),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ],
                          )
                        : null,
                    child: Center(
                      child: IconTheme(
                        data: IconThemeData(
                          color: selected ? accentColor : labelColor,
                        ),
                        child: selected ? activeIcon : inactiveIcon,
                      ),
                    ),
                  ),
                ),
                if (showLabel) ...[
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 12 * labelScale,
                      color: selected ? accentColor : labelColor,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
