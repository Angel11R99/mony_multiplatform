import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import '../../../core/widgets/mony_confirm_dialog.dart';
import '../../../core/theme/coquette_visuals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money/money_formatter.dart';
import '../domain/app_preferences.dart';
import 'preferences_controller.dart';
import '../../notifications/presentation/notifications_providers.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ajustes')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              '¿Qué quieres configurar?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const _SectionHeading(
              title: 'PREFERENCIAS',
              subtitle: 'Personaliza Mony y ajusta la navegación.',
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  _SettingsDestination(
                    icon: Icons.palette_outlined,
                    title: 'Personalización',
                    subtitle: 'Tema, colores y formato de moneda',
                    routeName: 'settingsPersonalization',
                  ),
                  const Divider(height: 1),
                  _SettingsDestination(
                    icon: Icons.navigation_outlined,
                    title: 'Navegación',
                    subtitle: 'Módulos y etiquetas de la barra',
                    routeName: 'settingsNavigation',
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const _SectionHeading(
              title: 'GESTIÓN FINANCIERA',
              subtitle: 'Organiza tus categorías, ciclos y presupuesto.',
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  _SettingsDestination(
                    icon: Icons.payment_outlined,
                    title: 'Métodos de pago',
                    subtitle: 'Administra tarjetas, efectivo y cuentas',
                    routeName: 'paymentMethods',
                  ),
                  const Divider(height: 1),
                  _SettingsDestination(
                    icon: Icons.category_outlined,
                    title: 'Administrar categorías',
                    subtitle: 'Categorías de ingresos y gastos',
                    routeName: 'settingsCategories',
                  ),
                  const Divider(height: 1),
                  _SettingsDestination(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Presupuesto y ciclos',
                    subtitle: 'Límites, período y alertas financieras',
                    routeName: 'settingsFinance',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const _SectionHeading(
              title: 'HERRAMIENTAS',
              subtitle:
                  'Accesos para registrar, consultar y respaldar tus datos.',
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  _SettingsDestination(
                    icon: Icons.file_upload_outlined,
                    title: 'Exportar datos',
                    subtitle: 'Descarga tus reportes financieros',
                    routeName: 'exports',
                  ),
                  const Divider(height: 1),
                  _SettingsDestination(
                    icon: Icons.backup_outlined,
                    title: 'Copia de seguridad',
                    subtitle: 'Respalda o restaura tu información',
                    routeName: 'backup',
                  ),
                  const Divider(height: 1),
                  _SettingsDestination(
                    icon: Icons.qr_code_scanner_outlined,
                    title: 'Escanear producto',
                    subtitle: 'Consulta y agrega productos a tus listas',
                    routeName: 'barcodeScan',
                  ),
                  const Divider(height: 1),
                  _SettingsDestination(
                    icon: Icons.receipt_long_outlined,
                    title: 'Escanear ticket',
                    subtitle: 'Prepara movimientos desde un recibo',
                    routeName: 'receiptScan',
                  ),
                  const Divider(height: 1),
                  _SettingsDestination(
                    icon: Icons.widgets_outlined,
                    title: 'Widgets de Mony',
                    subtitle: 'Consulta un resumen desde tu pantalla',
                    routeName: 'widgets',
                  ),
                  const Divider(height: 1),
                  _SettingsDestination(
                    icon: Icons.info_outline,
                    title: 'Acerca de Mony',
                    subtitle: 'Información de la aplicación',
                    routeName: 'about',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.pushNamed('privacy'),
              icon: const Icon(Icons.privacy_tip_outlined),
              label: const Text('Privacidad y datos'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SettingsDestination extends StatelessWidget {
  const _SettingsDestination({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.routeName,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => context.pushNamed(routeName),
  );
}

class NavigationSettingsPage extends ConsumerWidget {
  const NavigationSettingsPage({super.key});

  static const _titles = <String, (String, String)>{
    'home': ('Inicio', 'Resumen financiero y movimientos recientes'),
    'recurring': ('Fijos', 'Compromisos recurrentes'),
    'obligations': ('Recordatorios', 'Pagos y cobros pendientes'),
    'savings': ('Ahorros', 'Metas y aportaciones'),
    'shoppingLists': ('Lista', 'Listas de compras'),
    'statistics': ('Estadísticas', 'Reportes del período'),
    'cyclePlan': ('Plan de ciclo', 'Presupuesto y planificación'),
    'transactions': ('Historial', 'Movimientos y filtros'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appPreferencesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Navegación')),
      body: preferences.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(
          child: Text('No pudimos cargar las preferencias de navegación.'),
        ),
        data: (value) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Elige los módulos que aparecen en la barra principal.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  for (final id in defaultNavigationModuleIds)
                    SwitchListTile.adaptive(
                      title: Text(_titles[id]!.$1),
                      subtitle: Text(_titles[id]!.$2),
                      value: value.visibleNavigationModules.contains(id),
                      onChanged: (enabled) {
                        final modules = [...value.visibleNavigationModules];
                        if (enabled) {
                          modules.add(id);
                        } else if (modules.length > 1) {
                          modules.remove(id);
                        }
                        ref
                            .read(appPreferencesProvider.notifier)
                            .setVisibleNavigationModules(
                              defaultNavigationModuleIds
                                  .where(modules.contains)
                                  .toList(),
                            );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'La barra conserva al menos un módulo visible.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalizationSettingsPage extends ConsumerStatefulWidget {
  const PersonalizationSettingsPage({super.key});

  @override
  ConsumerState<PersonalizationSettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<PersonalizationSettingsPage> {
  static const _colorOptions = <_ColorOption>[
    _ColorOption('Lavanda Mony', 0xFFC8A8F4),
    _ColorOption('Rojo', 0xFFEF4444),
    _ColorOption('Rosa', 0xFFEC4899),
    _ColorOption('Morado', 0xFF9333EA),
    _ColorOption('Violeta', 0xFF7C3AED),
    _ColorOption('Azul', 0xFF3B82F6),
    _ColorOption('Azul claro', 0xFF0891B2),
    _ColorOption('Turquesa', 0xFF0D9488),
    _ColorOption('Verde', 0xFF16A34A),
    _ColorOption('Lima', 0xFF65A30D),
    _ColorOption('Amarillo', 0xFFEAB308),
    _ColorOption('Ámbar', 0xFFD97706),
    _ColorOption('Naranja', 0xFFEA580C),
    _ColorOption('Blanco', 0xFFFFFFFF),
    _ColorOption('Gris', 0xFF71717A),
    _ColorOption('Negro', 0xFF000000),
  ];

  void _save(Future<void> Function() action) {
    action().catchError((_) {
      if (!mounted) return;
      MonyFeedback.error(
        context,
        'No se pudo guardar el ajuste. Inténtalo de nuevo.',
      );
    });
  }

  Future<void> _resetPreferences() async {
    final shouldReset = await MonyConfirmDialog.show(
      context,
      title: 'Restaurar preferencias',
      message:
          'Se restablecerán el tema, los colores, el formato de moneda y los recordatorios.',
      confirmLabel: 'Restaurar',
      destructive: true,
    );

    if (!mounted || shouldReset != true) return;
    _save(() => ref.read(appPreferencesProvider.notifier).reset());
  }

  Future<void> _setNotificationsEnabled(bool enabled) async {
    try {
      if (enabled &&
          !await ref.read(notificationClientProvider).requestPermission()) {
        if (mounted) {
          MonyFeedback.error(
            context,
            'No se concedió el permiso para mostrar avisos.',
          );
        }
        return;
      }
      await ref
          .read(appPreferencesProvider.notifier)
          .setNotificationsEnabled(enabled);
    } catch (_) {
      if (mounted) {
        MonyFeedback.error(context, 'No se pudo actualizar este ajuste.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(appPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalización'),
        leading: IconButton(
          tooltip: 'Volver a Ajustes',
          onPressed: () =>
              context.canPop() ? context.pop() : context.goNamed('settings'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: preferences.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            _LoadError(onRetry: () => ref.invalidate(appPreferencesProvider)),
        data: (value) {
          final colorOptions = value.visualTheme == AppVisualTheme.coquetteBloom
              ? <_ColorOption>[
                  _ColorOption(
                    'Berry Rose',
                    CoquetteThemeColors.defaults.berry.toARGB32(),
                  ),
                  _ColorOption(
                    'Blush Pink',
                    CoquetteThemeColors.defaults.blush.toARGB32(),
                  ),
                  _ColorOption(
                    'Soft Lavender',
                    CoquetteThemeColors.defaults.lavender.toARGB32(),
                  ),
                  _ColorOption(
                    'Champagne',
                    CoquetteThemeColors.defaults.champagne.toARGB32(),
                  ),
                  ..._colorOptions,
                ]
              : _colorOptions;
          return _SettingsContent(
            preferences: value,
            colorOptions: colorOptions,
            onThemeChanged: (mode) => _save(
              () =>
                  ref.read(appPreferencesProvider.notifier).setThemeMode(mode),
            ),
            onVisualThemeChanged: (theme) => _save(
              () => ref
                  .read(appPreferencesProvider.notifier)
                  .setVisualTheme(theme),
            ),
            onPrimaryColorChanged: (color) => _save(
              () => ref
                  .read(appPreferencesProvider.notifier)
                  .setPrimaryColor(color),
            ),
            onAccentColorChanged: (color) => _save(
              () => ref
                  .read(appPreferencesProvider.notifier)
                  .setAccentColor(color),
            ),
            onCurrencyFormatChanged: (style) => _save(
              () => ref
                  .read(appPreferencesProvider.notifier)
                  .setCurrencyFormatStyle(style),
            ),
            onNotificationsChanged: _setNotificationsEnabled,
            onReset: _resetPreferences,
          );
        },
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent({
    required this.preferences,
    required this.colorOptions,
    required this.onThemeChanged,
    required this.onVisualThemeChanged,
    required this.onPrimaryColorChanged,
    required this.onAccentColorChanged,
    required this.onCurrencyFormatChanged,
    required this.onNotificationsChanged,
    required this.onReset,
  });

  final AppPreferences preferences;
  final List<_ColorOption> colorOptions;
  final ValueChanged<AppThemeMode> onThemeChanged;
  final ValueChanged<AppVisualTheme> onVisualThemeChanged;
  final ValueChanged<int> onPrimaryColorChanged;
  final ValueChanged<int> onAccentColorChanged;
  final ValueChanged<CurrencyFormatStyle> onCurrencyFormatChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bloom = preferences.visualTheme == AppVisualTheme.coquetteBloom;
    final primaryColor =
        bloom &&
            preferences.primaryColorArgb ==
                AppPreferences.defaults.primaryColorArgb
        ? CoquetteThemeColors.defaults.berry.toARGB32()
        : preferences.primaryColorArgb;
    final accentColor =
        bloom &&
            preferences.accentColorArgb ==
                AppPreferences.defaults.accentColorArgb
        ? CoquetteThemeColors.defaults.champagne.toARGB32()
        : preferences.accentColorArgb;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Text(
              'Haz Mony tuya',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Ajusta la apariencia y la forma de mostrar tu dinero. Tus cambios se guardan en este dispositivo.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            const _SectionHeading(
              title: 'TEMA',
              subtitle: 'Elige cómo se adapta Mony a la luz de tu entorno.',
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 430) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final mode in AppThemeMode.values)
                        _ThemeChoiceChip(
                          mode: mode,
                          selected: preferences.themeMode == mode,
                          onSelected: () => onThemeChanged(mode),
                        ),
                    ],
                  );
                }

                return SegmentedButton<AppThemeMode>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: AppThemeMode.system,
                      label: Text('Sistema'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.light,
                      label: Text('Claro'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.dark,
                      label: Text('Oscuro'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                  selected: {preferences.themeMode},
                  onSelectionChanged: (selection) =>
                      onThemeChanged(selection.first),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Estilo visual',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final options = <Widget>[
                  _VisualThemeChoice(
                    theme: AppVisualTheme.mony,
                    selected: preferences.visualTheme == AppVisualTheme.mony,
                    onSelected: () => onVisualThemeChanged(AppVisualTheme.mony),
                  ),
                  _VisualThemeChoice(
                    theme: AppVisualTheme.japaneseSumie,
                    selected:
                        preferences.visualTheme == AppVisualTheme.japaneseSumie,
                    onSelected: () =>
                        onVisualThemeChanged(AppVisualTheme.japaneseSumie),
                  ),
                  _VisualThemeChoice(
                    theme: AppVisualTheme.coquetteBloom,
                    selected:
                        preferences.visualTheme == AppVisualTheme.coquetteBloom,
                    onSelected: () =>
                        onVisualThemeChanged(AppVisualTheme.coquetteBloom),
                  ),
                ];
                if (constraints.maxWidth < 560) {
                  return Wrap(spacing: 8, runSpacing: 4, children: options);
                }
                return Row(
                  children: [
                    for (var i = 0; i < options.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(child: options[i]),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            const _SectionHeading(
              title: 'COLORES',
              subtitle:
                  'Elige los tonos que identifican tu espacio financiero.',
            ),
            const SizedBox(height: 12),
            _ColorPreference(
              title: 'Color principal',
              description: 'Acciones y elementos destacados',
              selectedColor: primaryColor,
              options: colorOptions,
              onSelected: onPrimaryColorChanged,
            ),
            const SizedBox(height: 14),
            _ColorPreference(
              title: 'Color secundario',
              description: 'Acentos y detalles visuales',
              selectedColor: accentColor,
              options: colorOptions,
              onSelected: onAccentColorChanged,
            ),
            const SizedBox(height: 14),
            _ColorPreview(
              preferences: preferences,
              primaryArgb: primaryColor,
              accentArgb: accentColor,
            ),
            const SizedBox(height: 28),
            const _SectionHeading(
              title: 'MONEDA Y FORMATO',
              subtitle: 'Mony comienza con pesos dominicanos.',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_outlined,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Peso dominicano'),
                              SizedBox(height: 2),
                              Text('DOP · República Dominicana'),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle, size: 20),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text('Mostrar importes como'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('RD\$'),
                          selected:
                              preferences.currencyFormatStyle ==
                              CurrencyFormatStyle.symbol,
                          onSelected: (_) => onCurrencyFormatChanged(
                            CurrencyFormatStyle.symbol,
                          ),
                        ),
                        ChoiceChip(
                          label: const Text('DOP'),
                          selected:
                              preferences.currencyFormatStyle ==
                              CurrencyFormatStyle.code,
                          onSelected: (_) =>
                              onCurrencyFormatChanged(CurrencyFormatStyle.code),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Vista previa · ${MoneyFormatter.formatDopMinorUnits(2500000, style: preferences.currencyFormatStyle)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const _SectionHeading(
              title: 'RECORDATORIOS',
              subtitle:
                  'Recibe avisos locales de vencimientos y movimientos recurrentes.',
            ),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile.adaptive(
                secondary: const Icon(Icons.notifications_active_outlined),
                title: const Text('Activar notificaciones'),
                subtitle: const Text(
                  'Obligaciones: el día del vencimiento a las 9:00. Recurrentes: el día anterior a las 9:00.',
                ),
                value: preferences.notificationsEnabled,
                onChanged: onNotificationsChanged,
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButton.icon(
              onPressed: () => context.pushNamed('privacy'),
              icon: const Icon(Icons.privacy_tip_outlined),
              label: const Text('Privacidad y datos'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Restaurar preferencias originales'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisualThemeChoice extends StatelessWidget {
  const _VisualThemeChoice({
    required this.theme,
    required this.selected,
    required this.onSelected,
  });
  final AppVisualTheme theme;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (theme) {
      AppVisualTheme.mony => ('Mony', Icons.auto_awesome_outlined),
      AppVisualTheme.japaneseSumie => ('Japanese Sumi-e', Icons.brush_outlined),
      AppVisualTheme.coquetteBloom => (
        'Coquette Bloom',
        Icons.local_florist_outlined,
      ),
    };
    return ChoiceChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _ThemeChoiceChip extends StatelessWidget {
  const _ThemeChoiceChip({
    required this.mode,
    required this.selected,
    required this.onSelected,
  });

  final AppThemeMode mode;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (mode) {
      AppThemeMode.system => ('Sistema', Icons.brightness_auto_outlined),
      AppThemeMode.light => ('Claro', Icons.light_mode_outlined),
      AppThemeMode.dark => ('Oscuro', Icons.dark_mode_outlined),
    };

    return ChoiceChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}

class _ColorPreference extends StatelessWidget {
  const _ColorPreference({
    required this.title,
    required this.description,
    required this.selectedColor,
    required this.options,
    required this.onSelected,
  });

  final String title;
  final String description;
  final int selectedColor;
  final List<_ColorOption> options;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 3),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: [
              for (final option in options)
                _ColorSwatch(
                  option: option,
                  selected: option.argb == selectedColor,
                  onTap: () => onSelected(option.argb),
                ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _chooseCustomColor(context),
              icon: const Icon(Icons.colorize_outlined),
              label: const Text('Elegir color personalizado'),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _chooseCustomColor(BuildContext context) async {
    final selected = await showDialog<Color>(
      context: context,
      builder: (context) =>
          _CustomColorDialog(initialColor: Color(selectedColor)),
    );
    if (selected != null) onSelected(selected.toARGB32() | 0xFF000000);
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _ColorOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: option.name,
    child: Tooltip(
      message: option.name,
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        iconSize: 23,
        icon: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(option.argb),
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: SizedBox(
            width: 34,
            height: 34,
            child: selected
                ? Icon(
                    Icons.check,
                    size: 19,
                    color: Color(option.argb).computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                  )
                : null,
          ),
        ),
      ),
    ),
  );
}

class _ColorPreview extends StatelessWidget {
  const _ColorPreview({
    required this.preferences,
    required this.primaryArgb,
    required this.accentArgb,
  });

  final AppPreferences preferences;
  final int primaryArgb;
  final int accentArgb;

  @override
  Widget build(BuildContext context) {
    final primary = Color(primaryArgb);
    final accent = Color(accentArgb);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vista previa',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Acción principal',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.circle, size: 18, color: accent),
                const SizedBox(width: 6),
                Text('Tu paleta', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: 0.68,
                minHeight: 9,
                color: primary,
                backgroundColor: primary.withValues(alpha: 0.16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomColorDialog extends StatefulWidget {
  const _CustomColorDialog({required this.initialColor});

  final Color initialColor;

  @override
  State<_CustomColorDialog> createState() => _CustomColorDialogState();
}

class _CustomColorDialogState extends State<_CustomColorDialog> {
  late HSVColor _selected;

  @override
  void initState() {
    super.initState();
    _selected = HSVColor.fromColor(widget.initialColor);
  }

  @override
  Widget build(BuildContext context) {
    final color = _selected.toColor();

    return AlertDialog(
      title: const Text('Color personalizado'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Semantics(
                label: 'Vista previa del color seleccionado',
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: color,
                  child: const Icon(
                    Icons.palette_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _ColorSlider(
              label: 'Tono',
              value: _selected.hue,
              max: 360,
              divisions: 360,
              onChanged: (value) =>
                  setState(() => _selected = _selected.withHue(value)),
            ),
            _ColorSlider(
              label: 'Saturación',
              value: _selected.saturation,
              max: 1,
              divisions: 100,
              onChanged: (value) =>
                  setState(() => _selected = _selected.withSaturation(value)),
            ),
            _ColorSlider(
              label: 'Luminosidad',
              value: _selected.value,
              max: 1,
              divisions: 100,
              onChanged: (value) =>
                  setState(() => _selected = _selected.withValue(value)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, color),
          child: const Text('Usar este color'),
        ),
      ],
    );
  }
}

class _ColorSlider extends StatelessWidget {
  const _ColorSlider({
    required this.label,
    required this.value,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      Slider(
        value: value,
        max: max,
        divisions: divisions,
        label: label == 'Tono'
            ? '${value.round()}°'
            : '${(value * 100).round()}%',
        onChanged: onChanged,
      ),
    ],
  );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.settings_outlined, size: 38),
          const SizedBox(height: 12),
          const Text('No pudimos cargar tus preferencias.'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    ),
  );
}

class _ColorOption {
  const _ColorOption(this.name, this.argb);

  final String name;
  final int argb;
}
