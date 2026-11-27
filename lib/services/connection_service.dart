
import 'dart:io';

class ConnectionService {
  Socket? _socket;

  bool get isConnected => _socket != null;

  Future<bool> checkAddress({
    required String address,
    required int port,
  }) async {
    try {
      final socket = await Socket.connect(
        address,
        port,
        timeout: const Duration(seconds: 5),
      );

      socket.destroy();
      return true;
    } on SocketException {
      return false;
    } on Exception {
      return false;
    }
  }

  Future<void> disconnect() async {
    _socket?.destroy();
    _socket = null;
  }
}
