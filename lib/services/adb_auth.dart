
import 'package:flutter_adb/adb_crypto.dart';

import 'adb_key_manager.dart';

class AdbAuth {
  final AdbKeyManager _keys = AdbKeyManager();

  Future<AdbCrypto> loadCrypto() {
    return _keys.loadOrCreate();
  }

  Future<void> clearKeys() {
    return _keys.clearKeys();
  }
}
