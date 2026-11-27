
import 'package:adb_direct/adb_direct.dart';

import 'direct_adb_key_manager.dart';

class RemoteDeviceService {
  final DirectAdbKeyManager _keyManager =
      DirectAdbKeyManager();

  AdbConnection? _connection;

  bool get isConnected =>
      _connection != null && !_connection!.isClosed;

  Future<bool> pair({
    required String host,
    required int pairingPort,
    required String code,
  }) async {
    final key = await _keyManager.loadOrCreate();

    try {
      await AdbPairing.pair(
        host,
        pairingPort,
        code: code,
        key: key,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> connect({
    required String host,
    required int port,
  }) async {
    await disconnect();

    final key = await _keyManager.loadOrCreate();

    try {
      _connection = await AdbConnection.connect(
        host,
        port,
        key: key,
      );
      return true;
    } catch (_) {
      _connection = null;
      return false;
    }
  }

  Future<String> execute(String command) async {
    final connection = _connection;

    if (connection == null || connection.isClosed) {
      throw StateError('Device is not connected');
    }

    final result = await connection.shell.run(command);
    return result.stdoutText;
  }

  Future<void> disconnect() async {
    final connection = _connection;
    _connection = null;

    if (connection != null && !connection.isClosed) {
      await connection.close();
    }
  }
}
