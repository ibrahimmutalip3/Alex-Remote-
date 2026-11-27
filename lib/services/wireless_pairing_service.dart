
import 'package:flutter_adb/adb_pairing.dart' as adb;

import 'adb_auth.dart';

class WirelessPairingService {
  final AdbAuth _auth = AdbAuth();

  Future<bool> pair({
    required String host,
    required int port,
    required String pairingCode,
  }) async {
    final crypto = await _auth.loadCrypto();

    return adb.AdbPairing.pair(
      host,
      port,
      pairingCode,
      crypto,
    );
  }
}
