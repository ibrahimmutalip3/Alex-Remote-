
import 'dart:convert';
import 'dart:typed_data';

import 'adb_protocol.dart';

class AdbCommands {
  static const int protocolVersion = 0x01000001;
  static const int maxDataSize = 1024 * 1024;

  static Uint8List connect({
    String deviceName = 'Alex Remote',
  }) {
    final banner = 'host::' 
        'features=shell_v2,cmd,stat_v2,ls_v2;'
        'device=${Uri.encodeComponent(deviceName)}\u0000';

    return AdbProtocol.encode(
      command: 'CNXN',
      arg0: protocolVersion,
      arg1: maxDataSize,
      payload: utf8.encode(banner),
    );
  }

  static Uint8List authenticationTokenRequest(
    Uint8List token,
  ) {
    return AdbProtocol.encode(
      command: 'AUTH',
      arg0: 1,
      payload: token,
    );
  }

  static Uint8List openStream({
    required int localId,
    required String destination,
  }) {
    return AdbProtocol.encode(
      command: 'OPEN',
      arg0: localId,
      arg1: 0,
      payload: utf8.encode('$destination\u0000'),
    );
  }

  static Uint8List closeStream({
    required int localId,
    required int remoteId,
  }) {
    return AdbProtocol.encode(
      command: 'CLSE',
      arg0: localId,
      arg1: remoteId,
    );
  }
}
