import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/theme/mony_finance_colors.dart';
import 'package:mony_multiplatform/core/theme/mony_theme.dart';
import 'package:mony_multiplatform/core/theme/mony_tokens.dart';
import 'package:mony_multiplatform/core/widgets/mony_controls.dart';
import 'package:mony_multiplatform/core/widgets/mony_finance_widgets.dart';
import 'package:mony_multiplatform/core/widgets/mony_states.dart';
import 'package:mony_multiplatform/features/preferences/domain/app_preferences.dart';

void main() {
  group('Mony theme', () {
    test('supports light, dark, and system theme modes', () {
      expect(
        MonyTheme.light(AppPreferences.defaults).brightness,
        Brightness.light,
      );
      expect(
        MonyTheme.dark(AppPreferences.defaults).brightness,
        Brightness.dark,
      );
      expect(MonyTheme.themeMode(AppThemeMode.system), ThemeMode.system);
      expect(MonyTheme.themeMode(AppThemeMode.light), ThemeMode.light);
      expect(MonyTheme.themeMode(AppThemeMode.dark), ThemeMode.dark);
    });

    test('provides finance semantic colors for both brightness modes', () {
      final light = MonyTheme.light(
        AppPreferences.defaults,
      ).extension<MonyFinanceColors>()!;
      final dark = MonyTheme.dark(
        AppPreferences.defaults,
      ).extension<MonyFinanceColors>()!;

      expect(light.income, isNot(dark.income));
      expect(light.expense, isNot(dark.expense));
      expect(light.warning, isNot(dark.warning));
    });

    test('centralizes responsive and touch sizing tokens', () {
      expect(MonyBreakpoints.compact, lessThan(MonyBreakpoints.expanded));
      expect(MonySpace.x4, 16);
    });
  });

  testWidgets('finance components expose meaningful semantics', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: MonyTheme.dark(AppPreferences.defaults),
        home: Scaffold(
          body: Column(
            children: [
              const BalanceCard(
                label: 'Balance mensual',
                amount: 'RD\$ 12,450.00',
                supportingText: 'Ingresos menos gastos',
              ),
              const StatTile(
                title: 'Ingresos',
                value: 'RD\$ 15,000.00',
                icon: Icons.south_west,
                emphasis: AmountEmphasis.income,
              ),
              const EmptyState(
                title: 'Sin movimientos',
                message: 'Agrega tu primer movimiento.',
              ),
              MonyButton(
                label: 'Guardar',
                onPressed: () {},
                style: MonyButtonStyle.secondary,
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      find.bySemanticsLabel(
        'Balance mensual. RD\$ 12,450.00. Ingresos menos gastos',
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('Ingresos: RD\$ 15,000.00'), findsOneWidget);
    expect(find.text('Sin movimientos'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('large text and narrow layouts remain usable', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: MonyTheme.light(AppPreferences.defaults),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Scaffold(
          body: ListView(
            children: [
              const BalanceCard(
                label: 'Balance mensual con una etiqueta extensa',
                amount: 'RD\$ 123,456,789.00',
                supportingText: 'Ingresos menos gastos durante este periodo',
              ),
              const ErrorState(
                message: 'No pudimos cargar tu información financiera.',
                retryLabel: 'Intentar de nuevo',
                onRetry: _noop,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Intentar de nuevo'), findsOneWidget);
  });
}

void _noop() {}
