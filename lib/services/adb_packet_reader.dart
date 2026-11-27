
import 'dart:typed_data';

import 'adb_protocol.dart';
import 'adb_response.dart';

class AdbPacketReader {
  final List<int> _buffer = [];

  List<AdbResponse> addData(Uint8List data) {
    _buffer.addAll(data);

    final responses = <AdbResponse>[];

    while (_buffer.length >= AdbProtocol.headerSize) {
      final headerBytes = Uint8List.fromList(
        _buffer.sublist(0, AdbProtocol.headerSize),
      );

      final header = AdbProtocol.decodeHeader(headerBytes);

      if (header.dataLength > AdbProtocol.maxPayloadSize) {
        _buffer.clear();
        throw const FormatException('ADB payload is too large.');
      }

      final packetLength =
          AdbProtocol.headerSize + header.dataLength;

      if (_buffer.length < packetLength) {
        break;
      }

      final packet = Uint8List.fromList(
        _buffer.sublist(0, packetLength),
      );

      responses.add(AdbResponse.decode(packet));

      _buffer.removeRange(0, packetLength);
    }

    return responses;
  }

  void reset() {
    _buffer.clear();
  }

  int get bufferedBytes => _buffer.length;
}
