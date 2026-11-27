
import 'dart:io';
import 'dart:typed_data';

class AdbPairing {
  Socket? _socket;

  Future<bool> testPort({
    required String host,
    required int port,
  }) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
      );

      await socket.close();
      return true;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  Future<void> disconnect() async {
    final socket = _socket;
    _socket = null;
    await socket?.close();
  }

  Uint8List encodePairingCode(String code) {
    return Uint8List.fromList(code.codeUnits);
  }
}
