
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class AdbCrypto {
  static Uint8List generateNonce([int length = 32]) {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(length, (_) => random.nextInt(256)),
    );
  }

  static String encodeBase64(Uint8List data) {
    return base64.encode(data);
  }

  static Uint8List decodeBase64(String value) {
    return base64.decode(value);
  }

  static String generateDeviceName() {
    final nonce = generateNonce(4);
    return 'AlexRemote-${nonce.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
  }
}
