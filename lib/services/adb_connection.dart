
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class AdbConnection {
  Socket? _socket;
  bool get isConnected => _socket != null;

  Future<void> connect({
    required String host,
    required int port,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await disconnect();

    _socket = await Socket.connect(
      host,
      port,
      timeout: timeout,
    );
  }

  void send(Uint8List data) {
    final socket = _socket;
    if (socket == null) {
      throw StateError('Not connected');
    }
    socket.add(data);
  }

  Stream<Uint8List> get incoming {
    final socket = _socket;
    if (socket == null) {
      throw StateError('Not connected');
    }
    return socket.map((data) => Uint8List.fromList(data));
  }

  Future<void> disconnect() async {
    final socket = _socket;
    _socket = null;
    await socket?.close();
  }
}
