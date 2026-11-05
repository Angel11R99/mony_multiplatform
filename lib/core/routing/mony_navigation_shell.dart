import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/preferences/domain/app_preferences.dart';
import '../../features/preferences/presentation/preferences_controller.dart';
import '../theme/mony_tokens.dart';
import '../theme/sumi_visuals.dart';
import '../theme/coquette_visuals.dart';
import '../theme/cyberpunk_visuals.dart';

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
      for (var index = 0; index < _moduleIds.length; index++)
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
    final wide = MediaQuery.sizeOf(context).width >= MonyBreakpoints.expanded;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final japanese = preferences?.visualTheme == AppVisualTheme.japaneseSumie;
    final coquette = preferences?.visualTheme == AppVisualTheme.coquetteBloom;
    final cyberpunk = preferences?.visualTheme == AppVisualTheme.cyberpunk;
    final sumi = SumiThemeColors.maybeOf(context);
    final destinations = [
      for (final index in visibleIndices)
        _railDestination(index, japanese: japanese, accent: scheme.primary),
    ];
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedVisibleIndex,
              onDestinationSelected: (index) =>
                  _selectBranch(visibleIndices[index]),
              useIndicator: japanese ? false : true,
              indicatorColor: japanese ? Colors.transparent : null,
              indicatorShape: japanese
                  ? const RoundedRectangleBorder(side: BorderSide.none)
                  : null,
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

    if (coquette) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: SafeArea(
          top: false,
          child: CoquetteBottomNavigationBar(
            items: [
              for (final index in visibleIndices)
                CoquetteNavigationItem(
                  icon: _iconData[index],
                  label: _moduleLabels[index],
                ),
            ],
            selectedIndex: selectedVisibleIndex,
            onSelected: (index) => _selectBranch(visibleIndices[index]),
          ),
        ),
      );
    }

    if (cyberpunk) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: SafeArea(
          top: false,
          child: CyberBottomNavigationBar(
            items: [
              for (final index in visibleIndices)
                CyberNavigationItem(
                  icon: _iconData[index],
                  label: _moduleLabels[index],
                ),
            ],
            selectedIndex: selectedVisibleIndex,
            onSelected: (index) => _selectBranch(visibleIndices[index]),
          ),
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: japanese ? 108 : 88,
          child: TweenAnimationBuilder<double>(
            tween: Tween(
              begin: selectedVisibleIndex.toDouble(),
              end: selectedVisibleIndex.toDouble(),
            ),
            duration: japanese
                ? MonyMotion.durationFor(
                    context,
                    const Duration(milliseconds: 600),
                  )
                : Duration.zero,
            curve: Curves.easeInOutCubic,
            builder: (context, animatedIndex, _) => Stack(
              children: [
                if (japanese)
                  Positioned(
                    top: 10,
                    left: 20,
                    right: 20,
                    height: 80,
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: SumiNavigationPainter(
                          colors: sumi ?? SumiThemeColors.defaults,
                          activeIndex: animatedIndex,
                          itemCount: visibleIndices.length,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _MonyBottomNavigationBar(
                    itemIndices: visibleIndices,
                    selectedIndex: navigationShell.currentIndex,
                    japanese: japanese,
                    onSelected: _selectBranch,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  static const _moduleLabels = [
    'Inicio',
    'Fijos',
    'Recordatorios',
    'Ahorros',
    'Lista',
    'Estadísticas',
    'Plan de ciclo',
    'Historial',
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

  static NavigationRailDestination _railDestination(
    int index, {
    required bool japanese,
    required Color accent,
  }) {
    final destination = _railDestinations[index];
    if (!japanese) return destination;
    return NavigationRailDestination(
      icon: destination.icon,
      selectedIcon: CustomPaint(
        painter: _NavigationSelectionBrush(accent),
        child: destination.selectedIcon,
      ),
      label: destination.label,
      padding: destination.padding,
      indicatorColor: Colors.transparent,
    );
  }
}

class _MonyBottomNavigationBar extends StatelessWidget {
  const _MonyBottomNavigationBar({
    required this.itemIndices,
    required this.selectedIndex,
    required this.japanese,
    required this.onSelected,
  });

  final List<int> itemIndices;
  final int selectedIndex;
  final bool japanese;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final duration = MonyMotion.durationFor(context, MonyMotion.quick);
    return Container(
      height: japanese ? 80 : 68,
      margin: japanese
          ? const EdgeInsets.only(left: 20, right: 20, bottom: 20)
          : const EdgeInsets.fromLTRB(20, 4, 20, 8),
      decoration: BoxDecoration(
        color: japanese ? Colors.transparent : scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: japanese
            ? null
            : Border.all(color: scheme.outlineVariant.withValues(alpha: .5)),
        boxShadow: japanese
            ? null
            : [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: .08),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Row(
        children: [
          for (final index in itemIndices)
            Expanded(
              child: _NavigationButton(
                icon: MonyNavigationShell._iconData[index],
                label: MonyNavigationShell._moduleLabels[index],
                selected: index == selectedIndex,
                japanese: japanese,
                duration: duration,
                onTap: () => onSelected(index),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.japanese,
    required this.duration,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool japanese;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sumi = SumiThemeColors.maybeOf(context) ?? SumiThemeColors.defaults;
    final selectedDuration = MonyMotion.durationFor(
      context,
      const Duration(milliseconds: 400),
    );
    final sumiUnselected = Theme.of(context).brightness == Brightness.dark
        ? sumi.paper
        : sumi.inkGray;
    final foreground = japanese
        ? (selected ? sumi.gold : sumiUnselected)
        : (selected ? scheme.primary : scheme.onSurfaceVariant);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Center(
            child: japanese
                ? TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: selected ? 1 : 0),
                    duration: selectedDuration,
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) => Transform.translate(
                      key: selected
                          ? const ValueKey('sumi-selected-icon-lift')
                          : null,
                      offset: Offset(0, -.15625 * value),
                      child: Transform.scale(
                        key: selected
                            ? const ValueKey('sumi-selected-icon-scale')
                            : null,
                        scale: 1,
                        child: child,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: foreground,
                      size: selected ? 36 : 30,
                    ),
                  )
                : AnimatedContainer(
                    duration: duration,
                    curve: MonyMotion.standardCurve,
                    width: 48,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected ? scheme.secondaryContainer : null,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Icon(icon, color: foreground, size: 24),
                  ),
          ),
        ),
      ),
    );
  }
}

class _NavigationSelectionBrush extends CustomPainter {
  const _NavigationSelectionBrush(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Path()
      ..moveTo(2, size.height - 1.5)
      ..cubicTo(
        size.width * .35,
        size.height - 2.5,
        size.width * .68,
        size.height,
        size.width - 2,
        size.height - 1,
      );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.square,
    );
  }

  @override
  bool shouldRepaint(covariant _NavigationSelectionBrush oldDelegate) =>
      color != oldDelegate.color;
}
