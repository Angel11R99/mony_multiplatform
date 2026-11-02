import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database_provider.dart';
import '../../../core/database/encrypted_database_backup.dart';

final encryptedDatabaseBackupProvider = Provider<EncryptedDatabaseBackup>(
  (ref) => EncryptedDatabaseBackup(ref.watch(appDatabaseProvider)),
);
