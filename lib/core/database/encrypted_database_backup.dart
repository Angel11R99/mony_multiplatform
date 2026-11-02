import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'app_database.dart';

const _backupFormat = 'mony.encrypted-backup';
const _backupVersion = 1;
const _iterations = 600000;
const _maxBackupBytes = 64 * 1024 * 1024;
const _maxPayloadBytes = 47 * 1024 * 1024;
const _aad = 'mony.encrypted-backup:v1';

/// Exports and transactionally restores all user-owned rows in the Drift DB.
///
/// The backup is a portable JSON envelope encrypted with AES-256-GCM. Its
/// key is derived from a user passphrase with PBKDF2-HMAC-SHA256.
class EncryptedDatabaseBackup {
  EncryptedDatabaseBackup(this._database);

  final AppDatabase _database;

  static const _tableOrder = <String>[
    'categories',
    'payment_methods',
    'savings_goals',
    'budgets',
    'budget_cycles',
    'shopping_lists',
    'shopping_list_items',
    'shopping_adjustments',
    'shopping_payables',
    'transactions',
    'recurring_entries',
    'obligations',
    'obligation_payments',
  ];

  Future<Uint8List> create(String passphrase) async {
    _validatePassphrase(passphrase);
    final tables = await _database.transaction(() async {
      final snapshot = <String, List<Map<String, Object?>>>{};
      for (final table in _tableOrder) {
        final rows = await _database
            .customSelect('SELECT * FROM "$table"')
            .get();
        snapshot[table] = rows.map((row) => row.data).toList(growable: false);
      }
      return snapshot;
    });
    final payload = jsonEncode({
      'application': 'mony',
      'schemaVersion': _database.schemaVersion,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'tables': tables,
    });
    final clearBytes = utf8.encode(payload);
    if (clearBytes.length > _maxPayloadBytes) {
      throw const DatabaseBackupException(
        'La copia supera el tamaño permitido.',
      );
    }

    final cipher = AesGcm.with256bits();
    final salt = AesGcm.with256bits(nonceLength: 16).newNonce();
    final key = await _deriveKey(passphrase, salt);
    final box = await cipher.encrypt(
      clearBytes,
      secretKey: key,
      nonce: cipher.newNonce(),
      aad: utf8.encode(_aad),
    );
    final envelope = jsonEncode({
      'format': _backupFormat,
      'version': _backupVersion,
      'kdf': {
        'name': 'pbkdf2-hmac-sha256',
        'iterations': _iterations,
        'salt': base64Encode(salt),
      },
      'cipher': {
        'name': 'aes-256-gcm',
        'nonce': base64Encode(box.nonce),
        'mac': base64Encode(box.mac.bytes),
        'ciphertext': base64Encode(box.cipherText),
      },
    });
    final result = Uint8List.fromList(utf8.encode(envelope));
    if (result.length > _maxBackupBytes) {
      throw const DatabaseBackupException(
        'La copia supera el tamaño permitido.',
      );
    }
    return result;
  }

  Future<void> restore(Uint8List bytes, String passphrase) async {
    _validatePassphrase(passphrase);
    if (bytes.isEmpty || bytes.length > _maxBackupBytes) {
      throw const DatabaseBackupException('El archivo de copia no es válido.');
    }
    final envelope = _decodeEnvelope(bytes);
    final kdf = _asMap(
      envelope['kdf'],
      'La cabecera de la copia no es válida.',
    );
    final cipherData = _asMap(
      envelope['cipher'],
      'La cabecera de la copia no es válida.',
    );
    if (envelope['format'] != _backupFormat ||
        envelope['version'] != _backupVersion ||
        kdf['name'] != 'pbkdf2-hmac-sha256' ||
        kdf['iterations'] != _iterations ||
        cipherData['name'] != 'aes-256-gcm') {
      throw const DatabaseBackupException(
        'El formato de copia no es compatible.',
      );
    }

    try {
      final salt = _decodeBase64(kdf['salt'], length: 16);
      final nonce = _decodeBase64(cipherData['nonce'], length: 12);
      final mac = _decodeBase64(cipherData['mac'], length: 16);
      final encrypted = _decodeBase64(cipherData['ciphertext']);
      final key = await _deriveKey(passphrase, salt);
      final clear = await AesGcm.with256bits().decrypt(
        SecretBox(encrypted, nonce: nonce, mac: Mac(mac)),
        secretKey: key,
        aad: utf8.encode(_aad),
      );
      if (clear.length > _maxBackupBytes) {
        throw const DatabaseBackupException(
          'La copia supera el tamaño permitido.',
        );
      }
      final decoded = jsonDecode(utf8.decode(clear));
      final payload = _asMap(decoded, 'El contenido de la copia no es válido.');
      await _restoreTables(payload);
    } on DatabaseBackupException {
      rethrow;
    } catch (_) {
      throw const DatabaseBackupException(
        'No se pudo validar o restaurar la copia. Verifica la contraseña y el archivo.',
      );
    }
  }

  Future<void> _restoreTables(Map<String, dynamic> payload) async {
    if (payload['application'] != 'mony' ||
        payload['schemaVersion'] != _database.schemaVersion) {
      throw const DatabaseBackupException(
        'La copia pertenece a una versión de base de datos incompatible.',
      );
    }
    final sourceTables = _asMap(
      payload['tables'],
      'Faltan tablas en la copia de seguridad.',
    );
    if (sourceTables.length != _tableOrder.length ||
        !_tableOrder.every(sourceTables.containsKey)) {
      throw const DatabaseBackupException(
        'La copia no contiene el conjunto completo de datos de Mony.',
      );
    }

    final tableColumns = <String, Set<String>>{};
    for (final table in _tableOrder) {
      final info = await _database
          .customSelect('PRAGMA table_info("$table")')
          .get();
      tableColumns[table] = info.map((row) => row.read<String>('name')).toSet();
    }
    final normalized = <String, List<Map<String, Object?>>>{};
    for (final table in _tableOrder) {
      final rows = sourceTables[table];
      if (rows is! List) {
        throw const DatabaseBackupException('Hay datos inválidos en la copia.');
      }
      final columns = tableColumns[table]!;
      normalized[table] = rows
          .map((row) {
            final values = _asMap(row, 'Hay una fila inválida en la copia.');
            if (values.isEmpty ||
                values.keys.any((column) => !columns.contains(column)) ||
                !values.keys.toSet().containsAll(columns)) {
              throw const DatabaseBackupException(
                'La estructura de la copia no coincide con Mony.',
              );
            }
            return Map<String, Object?>.from(values);
          })
          .toList(growable: false);
    }

    await _database.transaction(() async {
      await _database.customStatement('PRAGMA defer_foreign_keys = ON');
      for (final table in _tableOrder.reversed) {
        await _database.customStatement('DELETE FROM "$table"');
      }
      for (final table in _tableOrder) {
        final columns = tableColumns[table]!.toList(growable: false);
        final quotedColumns = columns.map((column) => '"$column"').join(', ');
        final placeholders = List.filled(columns.length, '?').join(', ');
        final insert =
            'INSERT INTO "$table" ($quotedColumns) VALUES ($placeholders)';
        for (final row in normalized[table]!) {
          final values = columns.map((column) => row[column]).toList();
          await _database.customStatement(insert, values);
        }
      }
      final violations = await _database
          .customSelect('PRAGMA foreign_key_check')
          .get();
      if (violations.isNotEmpty) {
        throw const DatabaseBackupException(
          'La copia contiene referencias entre datos inválidas; no se aplicaron cambios.',
        );
      }
    });
    _database.markTablesUpdated(_database.allTables);
  }

  Future<SecretKey> _deriveKey(String passphrase, List<int> salt) {
    final algorithm = kIsWeb
        ? Pbkdf2.hmacSha256(iterations: _iterations, bits: 256)
        : BackgroundPbkdf2(
            macAlgorithm: Hmac.sha256(),
            iterations: _iterations,
            bits: 256,
          );
    return algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(passphrase)),
      nonce: salt,
    );
  }

  static Map<String, dynamic> _decodeEnvelope(Uint8List bytes) {
    try {
      return _asMap(
        jsonDecode(utf8.decode(bytes)),
        'El archivo de copia no es válido.',
      );
    } catch (_) {
      throw const DatabaseBackupException('El archivo de copia no es válido.');
    }
  }

  static Map<String, dynamic> _asMap(Object? value, String message) {
    if (value is Map<String, dynamic>) return value;
    throw DatabaseBackupException(message);
  }

  static List<int> _decodeBase64(Object? value, {int? length}) {
    if (value is! String || value.length > _maxBackupBytes * 2) {
      throw const DatabaseBackupException('El archivo de copia no es válido.');
    }
    final decoded = base64Decode(value);
    if (length != null && decoded.length != length) {
      throw const DatabaseBackupException('El archivo de copia no es válido.');
    }
    return decoded;
  }

  static void _validatePassphrase(String passphrase) {
    if (passphrase.trim().runes.length < 12) {
      throw const DatabaseBackupException(
        'Usa una contraseña de copia con al menos 12 caracteres.',
      );
    }
  }
}

class DatabaseBackupException implements Exception {
  const DatabaseBackupException(this.message);

  final String message;

  @override
  String toString() => message;
}
