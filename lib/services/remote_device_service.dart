
import 'adb_session_service.dart';
import 'adb_shell_service.dart';
import 'wireless_pairing_service.dart';

class RemoteDeviceService {
  final WirelessPairingService _pairing = WirelessPairingService();
  final AdbSessionService _session = AdbSessionService();

  bool get isConnected => _session.isConnected;

  Future<bool> pair({
    required String host,
    required int pairingPort,
    required String code,
  }) {
    return _pairing.pair(
      host: host,
      port: pairingPort,
      pairingCode: code,
    );
  }

  Future<bool> connect({
    required String host,
    required int port,
  }) {
    return _session.connect(
      host: host,
      port: port,
    );
  }

  Future<String> execute(String command) async {
    final connection = _session.connection;

    if (connection == null) {
      throw StateError('Device is not connected');
    }

    final shell = AdbShellService(connection);
    return shell.execute(command);
  }

  Future<void> disconnect() {
    return _session.disconnect();
  }
}
