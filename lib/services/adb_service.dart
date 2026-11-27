
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class AdbService {
  Socket? _socket;

  bool get isConnected => _socket != null;

  Future<void> connect({
    required String address,
    required int port,
  }) async {
    await disconnect();

    _socket = await Socket.connect(
      address,
      port,
      timeout: const Duration(seconds: 8),
    );
  }

  Uint8List createPacket(String command, String data) {
    final bytes = utf8.encode(data);
    final commandBytes = ascii.encode(command);

    if (commandBytes.length != 4) {
      throw ArgumentError('ADB command must contain 4 characters.');
    }

    final checksum = bytes.fold<int>(
      0,
      (sum, byte) => (sum + byte) & 0xFFFFFFFF,
    );

    final packet = ByteData(24 + bytes.length);

    for (var i = 0; i < 4; i++) {
      packet.setUint8(i, commandBytes[i]);
    }

    packet.setUint32(4, commandBytes.fold<int>(
      0,
      (value, byte) => (value << 8) | byte,
    ), Endian.little);

    packet.setUint32(8, bytes.length, Endian.little);
    packet.setUint32(12, checksum, Endian.little);
    packet.setUint32(16, commandBytes.fold<int>(
      0,
      (value, byte) => (value << 8) | byte,
    ) ^ 0xFFFFFFFF, Endian.little);

    for (var i = 0; i < bytes.length; i++) {
      packet.setUint8(24 + i, bytes[i]);
    }

    return packet.buffer.asUint8List();
  }

  Future<void> disconnect() async {
    await _socket?.close();
    _socket = null;
  }
}
