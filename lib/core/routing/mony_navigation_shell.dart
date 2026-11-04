import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nav_bar/nav_bar.dart';

import '../../features/preferences/domain/app_preferences.dart';
import '../../features/preferences/presentation/preferences_controller.dart';
import '../theme/mony_tokens.dart';
import '../theme/sumi_visuals.dart';
import '../theme/coquette_visuals.dart';

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
    final sumi = SumiThemeColors.maybeOf(context);
    final destinations = [
      for (final index in visibleIndices)
        _railDestination(index, japanese: japanese, accent: scheme.primary),
    ];
    final sumieNavTheme = FuturisticTheme(
      name: 'Japanese Sumi-e',
      glowGradient: LinearGradient(
        colors: [scheme.secondary.withValues(alpha: .15), Colors.transparent],
      ),
      accentColor: scheme.secondary,
      baseColor: scheme.surfaceContainerLow,
      particleColor: scheme.outline,
      backgroundColor: scheme.surfaceContainerLow,
      customColors: {
        'paperColor': sumi?.deepInk ?? scheme.surfaceContainerLow,
        'inkColor': scheme.primary,
        'sealColor': scheme.secondary,
        'impactColor': scheme.secondary,
      },
      effectToggles: const {
        'showPaperTexture': false,
        'showInkSplatter': false,
        'showSeal': false,
        'showImpact': false,
      },
    );

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

    final items = <NavBarItem>[
      for (final index in visibleIndices)
        NavBarItem(
          icon: _iconData[index],
          customIcon: japanese
              ? Transform.translate(
                  offset: Offset(
                    0,
                    index == navigationShell.currentIndex ? 5 : 0,
                  ),
                  child: Icon(_iconData[index], color: scheme.onSurface),
                )
              : null,
        ),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Stack(
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
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            Transform.translate(
              offset: const Offset(0, 10),
              child: FuturisticNavBar(
                selectedIndex: selectedVisibleIndex,
                onItemSelected: (index) => _selectBranch(visibleIndices[index]),
                items: items,
                style: japanese ? NavBarStyle.sumi : NavBarStyle.synapse,
                theme: japanese ? sumieNavTheme : FuturisticTheme.cyberpunk(),
                iconAnimationType: japanese
                    ? IconAnimationType.fade
                    : IconAnimationType.slide,
                showGlow: !japanese,
                showLiquid: !japanese,
              ),
            ),
          ],
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
