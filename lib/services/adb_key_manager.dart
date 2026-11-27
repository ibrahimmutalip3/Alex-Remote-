
import 'dart:convert';

import 'package:flutter_adb/adb_crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdbKeyManager {
  static const _storage = FlutterSecureStorage();
  static const _storageKey = 'alex_remote_adb_rsa';

  Future<AdbCrypto> loadOrCreate() async {
    final saved = await _storage.read(key: _storageKey);

    if (saved != null) {
      final map = jsonDecode(saved) as Map<String, dynamic>;

      return AdbCrypto(
        keyPair: AdbCrypto.keyPairFromStorageMap(map),
        adbKeyName: 'alexremote@ios',
      );
    }

    final keyPair = AdbCrypto.generateAdbKeyPair();

    final crypto = AdbCrypto(
      keyPair: keyPair,
      adbKeyName: 'alexremote@ios',
    );

    await _storage.write(
      key: _storageKey,
      value: jsonEncode(crypto.exportKeyPairForStorage()),
    );

    return crypto;
  }

  Future<void> clearKeys() async {
    await _storage.delete(key: _storageKey);
  }
}
