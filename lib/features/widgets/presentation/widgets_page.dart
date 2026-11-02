import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/mony_feedback.dart';
import 'package:home_widget/home_widget.dart';

import 'widgets_providers.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final ios = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(title: const Text('Widgets de Mony')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                android
                    ? 'Agrega tus resúmenes y accesos a la pantalla de inicio.'
                    : ios
                    ? 'Agrega un widget desde la galería de widgets de iOS. Mantén presionada la pantalla de inicio, toca Editar y luego Añadir widget.'
                    : 'Los widgets de pantalla de inicio están disponibles en Android y iOS.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Los importes se comparten solo con los widgets del dispositivo y se actualizan al abrir Mony y al cambiar tus datos.',
              ),
              const SizedBox(height: 16),
              for (final kind in FinanceWidgetKind.values)
                _WidgetCatalogTile(kind: kind, canPin: android),
            ],
          ),
        ),
      ),
    );
  }
}

class _WidgetCatalogTile extends StatefulWidget {
  const _WidgetCatalogTile({required this.kind, required this.canPin});

  final FinanceWidgetKind kind;
  final bool canPin;

  @override
  State<_WidgetCatalogTile> createState() => _WidgetCatalogTileState();
}

class _WidgetCatalogTileState extends State<_WidgetCatalogTile> {
  bool _adding = false;

  Future<void> _addWidget() async {
    setState(() => _adding = true);
    try {
      await HomeWidget.requestPinWidget(
        androidName: widget.kind.qualifiedAndroidReceiver,
      );
      if (!mounted) return;
      MonyFeedback.info(context, 'Solicitud enviada: ${widget.kind.label}.');
    } catch (_) {
      if (!mounted) return;
      MonyFeedback.info(
        context,
        'Este launcher no permite agregar el widget directamente. Agrégalo desde su lista de widgets.',
      );
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) => Card.outlined(
    child: ListTile(
      leading: const Icon(Icons.widgets_outlined),
      title: Text(widget.kind.label),
      subtitle: Text(widget.kind.description),
      trailing: widget.canPin
          ? IconButton(
              tooltip: 'Agregar a inicio',
              onPressed: _adding ? null : _addWidget,
              icon: _adding
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_circle_outline),
            )
          : null,
    ),
  );
}
