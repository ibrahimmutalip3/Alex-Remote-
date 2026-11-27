
import 'dart:convert';

import 'package:flutter_adb/flutter_adb.dart';

class AdbShellService {
  final AdbConnection connection;

  AdbShellService(this.connection);

  Future<String> execute(String command) async {
    final shell = await connection.openShell();
    final output = StringBuffer();

    final subscription = shell.onPayload.listen((payload) {
      output.write(utf8.decode(payload, allowMalformed: true));
    });

    await shell.writeString('$command\n');
    await Future.delayed(const Duration(milliseconds: 350));

    await subscription.cancel();
    await shell.sendClose();

    return output.toString();
  }
}
