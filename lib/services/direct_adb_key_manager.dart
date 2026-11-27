
import 'package:adb_direct/adb_direct.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DirectAdbKeyManager {
  static const _storage = FlutterSecureStorage();
  static const _key = 'alex_remote_direct_adb_key';

  Future<AdbKeyPair> loadOrCreate() async {
    final saved = await _storage.read(key: _key);

    if (saved != null) {
      return AdbKeyPair.fromPem(
        saved,
        comment: 'alexremote@ios',
      );
    }

    final keyPair = await AdbKeyPair.generate(
      comment: 'alexremote@ios',
    );

    await _storage.write(
      key: _key,
      value: keyPair.toPem(),
    );

    return keyPair;
  }
}
