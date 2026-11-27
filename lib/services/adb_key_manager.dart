

import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdbKeyManager {
  static const _storage = FlutterSecureStorage();

  static const _privateKeyKey = 'adb_private_key';
  static const _publicKeyKey = 'adb_public_key';

  final _algorithm = Ed25519();

  Future<void> generateAndSaveKeys() async {
    final keyPair = await _algorithm.newKeyPair();
    final privateKey = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();

    await _storage.write(
      key: _privateKeyKey,
      value: base64Encode(privateKey),
    );

    await _storage.write(
      key: _publicKeyKey,
      value: base64Encode(publicKey.bytes),
    );
  }

  Future<Uint8List?> getPrivateKey() async {
    final value = await _storage.read(key: _privateKeyKey);
    return value == null ? null : base64Decode(value);
  }

  Future<Uint8List?> getPublicKey() async {
    final value = await _storage.read(key: _publicKeyKey);
    return value == null ? null : base64Decode(value);
  }

  Future<void> clearKeys() async {
    await _storage.delete(key: _privateKeyKey);
    await _storage.delete(key: _publicKeyKey);
  }
}
