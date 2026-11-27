
import 'dart:typed_data';

import 'adb_key_manager.dart';
import 'adb_signature.dart';

class AdbAuth {
  final AdbKeyManager _keys = AdbKeyManager();
  final AdbSignature _signature = AdbSignature();

  Future<Uint8List?> signToken(Uint8List token) async {
    final privateKey = await _keys.getPrivateKey();

    if (privateKey == null) {
      return null;
    }

    return _signature.sign(
      privateKey: privateKey,
      message: token,
    );
  }

  Future<bool> hasKeys() async {
    final privateKey = await _keys.getPrivateKey();
    final publicKey = await _keys.getPublicKey();

    return privateKey != null && publicKey != null;
  }

  Future<void> generateKeys() async {
    await _keys.generateAndSaveKeys();
  }

  Future<void> clearKeys() async {
    await _keys.clearKeys();
  }
}
