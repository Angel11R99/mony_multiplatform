import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Privacidad y datos')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Tus finanzas permanecen bajo tu control.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const _PrivacySection(
              title: 'Datos guardados en este dispositivo',
              body:
                  'Mony guarda movimientos, categorías, métodos de pago, presupuestos, metas, obligaciones, listas y preferencias en la base local de la app. No necesitas crear una cuenta y Mony no sincroniza esos datos con un servidor propio.',
            ),
            const _PrivacySection(
              title: 'Funciones que usan internet',
              body:
                  'El escaneo de tickets procesa el texto en el dispositivo. Si solicitas buscar un producto por su código de barras, Mony envía ese código a Open Food Facts para consultar su catálogo; la consulta puede revelar a ese servicio tu dirección IP. El resultado se guarda en una caché local.',
            ),
            const _PrivacySection(
              title: 'Widgets y notificaciones',
              body:
                  'Los widgets reciben una instantánea local de importes y resúmenes para mostrarlos en la pantalla de inicio. Los widgets pueden revelar esos datos a quien vea la pantalla; puedes quitarlos desde el sistema. Los recordatorios se programan localmente.',
            ),
            const _PrivacySection(
              title: 'Copias y exportaciones',
              body:
                  'Las copias de seguridad se cifran con AES-256-GCM y una contraseña que solo tú conoces. Los archivos CSV, Excel y PDF que exportas no se cifran automáticamente: compártelos únicamente con destinos de confianza. La restauración reemplaza la base actual.',
            ),
            const _PrivacySection(
              title: 'Borrar o trasladar tus datos',
              body:
                  'Puedes exportar o crear una copia cifrada desde Exportar datos. Elimina registros desde sus módulos o desinstala Mony para borrar el almacenamiento local de la app. Las copias del dispositivo administradas por el sistema operativo dependen de la plataforma y de la configuración del dispositivo.',
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.pushNamed('backup'),
              icon: const Icon(Icons.enhanced_encryption_outlined),
              label: const Text('Administrar copia cifrada'),
            ),
            const SizedBox(height: 8),
            Text(
              'Para publicar Mony se debe completar y enlazar la política legal del responsable, incluidos sus datos de contacto y los requisitos del país de distribución.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(body, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}
