
import 'dart:typed_data';

import 'adb_protocol.dart';

class AdbResponse {
  final AdbPacketHeader header;
  final Uint8List payload;

  const AdbResponse({
    required this.header,
    required this.payload,
  });

  String get text => String.fromCharCodes(payload);

  bool get isOkay => header.command == 'OKAY';
  bool get isFailure => header.command == 'FAIL';
  bool get isConnection => header.command == 'CNXN';
  bool get isAuthentication => header.command == 'AUTH';

  static AdbResponse decode(Uint8List packet) {
    if (packet.length < AdbProtocol.headerSize) {
      throw const FormatException('Incomplete ADB packet.');
    }

    final header = AdbProtocol.decodeHeader(packet);

    if (header.dataLength > AdbProtocol.maxPayloadSize) {
      throw const FormatException('ADB payload is too large.');
    }

    if (packet.length != AdbProtocol.headerSize + header.dataLength) {
      throw const FormatException('Invalid ADB packet length.');
    }

    final payload = Uint8List.fromList(
      packet.sublist(AdbProtocol.headerSize),
    );

    final checksum = payload.fold<int>(
      0,
      (sum, byte) => (sum + byte) & 0xFFFFFFFF,
    );

    if (checksum != header.checksum) {
      throw const FormatException('Invalid ADB checksum.');
    }

    return AdbResponse(
      header: header,
      payload: payload,
    );
  }
}
