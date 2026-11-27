
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class AdbSignature {
  final Ed25519 _algorithm = Ed25519();

  Future<Uint8List> sign({
    required Uint8List privateKey,
    required Uint8List message,
  }) async {
    final keyPair = await _algorithm.newKeyPairFromSeed(privateKey);

    final signature = await _algorithm.sign(
      message,
      keyPair: keyPair,
    );

    return Uint8List.fromList(signature.bytes);
  }

  Future<bool> verify({
    required Uint8List publicKey,
    required Uint8List message,
    required Uint8List signature,
  }) async {
    final key = SimplePublicKey(
      publicKey,
      type: KeyPairType.ed25519,
    );

    return _algorithm.verify(
      message,
      signature: Signature(
        signature,
        publicKey: key,
      ),
    );
  }
}
