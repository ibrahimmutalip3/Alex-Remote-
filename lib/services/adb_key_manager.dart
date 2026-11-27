
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdbKeyManager {
  static const _storage = FlutterSecureStorage();

  static const _privateKeyKey = 'adb_private_key';
  static const _publicKeyKey = 'adb_public_key';

  Future<void> saveKeys({
    required Uint8List privateKey,
    required Uint8List publicKey,
  }) async {
    await _storage.write(
      key: _privateKeyKey,
      value: base64Encode(privateKey),
    );

    await _storage.write(
      key: _publicKeyKey,
      value: base64Encode(publicKey),
    );
  }

  Future<Uint8List?> getPrivateKey() async {
    final value = await _storage.read(key: _privateKeyKey);
    if (value == null) return null;
    return base64Decode(value);
  }

  Future<Uint8List?> getPublicKey() async {
    final value = await _storage.read(key: _publicKeyKey);
    if (value == null) return null;
    return base64Decode(value);
  }

  Future<void> clearKeys() async {
    await _storage.delete(key: _privateKeyKey);
    await _storage.delete(key: _publicKeyKey);
  }
}
