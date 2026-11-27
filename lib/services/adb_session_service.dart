
import 'package:flutter_adb/flutter_adb.dart';

import 'adb_auth.dart';

class AdbSessionService {
  final AdbAuth _auth = AdbAuth();

  AdbConnection? _connection;

  bool get isConnected => _connection != null;

  Future<bool> connect({
    required String host,
    required int port,
  }) async {
    await disconnect();

    final crypto = await _auth.loadCrypto();

    final connection = AdbConnection(
      host,
      port,
      crypto,
      verbose: true,
    );

    final connected = await connection.connect();

    if (connected) {
      _connection = connection;
    }

    return connected;
  }

  Future<void> disconnect() async {
    final connection = _connection;
    _connection = null;
    connection?.disconnect();
  }
}
