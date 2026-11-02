import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/encrypted_database_backup.dart';
import 'database_backup_providers.dart';

class DatabaseBackupPage extends ConsumerStatefulWidget {
  const DatabaseBackupPage({super.key});

  @override
  ConsumerState<DatabaseBackupPage> createState() => _DatabaseBackupPageState();
}

class _DatabaseBackupPageState extends ConsumerState<DatabaseBackupPage> {
  final _createPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _restorePassword = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _createPassword.dispose();
    _confirmPassword.dispose();
    _restorePassword.dispose();
    super.dispose();
  }

  Future<void> _createBackup() async {
    final password = _createPassword.text;
    if (password != _confirmPassword.text) {
      setState(() => _error = 'Las contraseñas no coinciden.');
      return;
    }
    await _run(() async {
      final bytes = await ref
          .read(encryptedDatabaseBackupProvider)
          .create(password);
      final now = DateTime.now();
      final date =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final saved = await FilePicker.saveFile(
        fileName: 'mony-backup-$date.monybackup',
        bytes: bytes,
        mimeType: 'application/octet-stream',
        dialogTitle: 'Guardar copia cifrada de Mony',
      );
      if (saved != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copia cifrada guardada.')),
        );
      }
    });
  }

  Future<void> _restoreBackup() async {
    if (_restorePassword.text.trim().runes.length < 12) {
      setState(() => _error = 'Escribe la contraseña de la copia.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reemplazar los datos actuales'),
        content: const Text(
          'La restauración reemplaza todos los datos de Mony por los de la copia. '
          'La operación se revierte automáticamente si falla la validación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _run(() async {
      final file = await FilePicker.pickFile(
        dialogTitle: 'Seleccionar copia cifrada de Mony',
        type: FileType.custom,
        allowedExtensions: const ['monybackup'],
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      await ref
          .read(encryptedDatabaseBackupProvider)
          .restore(Uint8List.fromList(bytes), _restorePassword.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos restaurados correctamente.')),
        );
      }
    });
  }

  Future<void> _run(Future<void> Function() operation) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await operation();
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error is DatabaseBackupException
              ? error.message
              : 'No se pudo completar la operación. Verifica el archivo e inténtalo de nuevo.',
        );
      }
    } finally {
      _createPassword.clear();
      _confirmPassword.clear();
      _restorePassword.clear();
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Copia de seguridad')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Crea una copia que solo tú puedas abrir.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'La copia incluye los datos financieros y catálogos guardados en este dispositivo. '
              'Se cifra con AES-256-GCM y una contraseña que no se guarda en Mony. '
              'Si la olvidas, no será posible recuperar la copia.',
            ),
            const SizedBox(height: 20),
            Text(
              'Crear copia cifrada',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _PasswordField(
              controller: _createPassword,
              label: 'Contraseña (12 caracteres mínimo)',
            ),
            const SizedBox(height: 8),
            _PasswordField(
              controller: _confirmPassword,
              label: 'Confirmar contraseña',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _busy ? null : _createBackup,
              icon: const Icon(Icons.lock_outline),
              label: const Text('Crear y guardar copia'),
            ),
            const Divider(height: 36),
            Text(
              'Restaurar una copia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _PasswordField(
              controller: _restorePassword,
              label: 'Contraseña de la copia',
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _busy ? null : _restoreBackup,
              icon: const Icon(Icons.restore),
              label: const Text('Seleccionar y restaurar copia'),
            ),
            if (_busy)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(),
              ),
            if (_error case final error?)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    obscureText: true,
    autocorrect: false,
    enableSuggestions: false,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );
}
