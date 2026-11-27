
import 'dart:convert';
import 'dart:typed_data';

class AdbPacketHeader {
  final String command;
  final int arg0;
  final int arg1;
  final int dataLength;
  final int checksum;

  const AdbPacketHeader({
    required this.command,
    required this.arg0,
    required this.arg1,
    required this.dataLength,
    required this.checksum,
  });
}

class AdbProtocol {
  static const int headerSize = 24;
  static const int maxPayloadSize = 1024 * 1024;

  static Uint8List encode({
    required String command,
    int arg0 = 0,
    int arg1 = 0,
    List<int> payload = const [],
  }) {
    if (command.length != 4 ||
        !ascii.encode(command).every((b) => b >= 32 && b <= 126)) {
      throw ArgumentError('Command must contain 4 ASCII characters.');
    }

    if (payload.length > maxPayloadSize) {
      throw ArgumentError('Payload is too large.');
    }

    final commandBytes = ascii.encode(command);

    final commandValue = commandBytes[0] |
        (commandBytes[1] << 8) |
        (commandBytes[2] << 16) |
        (commandBytes[3] << 24);

    final checksum = payload.fold<int>(
      0,
      (sum, byte) => (sum + byte) & 0xFFFFFFFF,
    );

    final result = Uint8List(headerSize + payload.length);
    final data = ByteData.sublistView(result);

    data.setUint32(0, commandValue, Endian.little);
    data.setUint32(4, arg0, Endian.little);
    data.setUint32(8, arg1, Endian.little);
    data.setUint32(12, payload.length, Endian.little);
    data.setUint32(16, checksum, Endian.little);
    data.setUint32(20, commandValue ^ 0xFFFFFFFF, Endian.little);

    result.setRange(headerSize, result.length, payload);

    return result;
  }

  static AdbPacketHeader decodeHeader(Uint8List bytes) {
    if (bytes.length < headerSize) {
      throw const FormatException('Incomplete ADB header.');
    }

    final data = ByteData.sublistView(bytes);

    final commandValue = data.getUint32(0, Endian.little);
    final magic = data.getUint32(20, Endian.little);

    if (magic != (commandValue ^ 0xFFFFFFFF)) {
      throw const FormatException('Invalid ADB command magic.');
    }

    final commandBytes = [
      commandValue & 0xFF,
      (commandValue >> 8) & 0xFF,
      (commandValue >> 16) & 0xFF,
      (commandValue >> 24) & 0xFF,
    ];

    return AdbPacketHeader(
      command: ascii.decode(commandBytes),
      arg0: data.getUint32(4, Endian.little),
      arg1: data.getUint32(8, Endian.little),
      dataLength: data.getUint32(12, Endian.little),
      checksum: data.getUint32(16, Endian.little),
    );
  }
}
