
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/saved_device.dart';

class SavedDeviceStore {
  static const _storage = FlutterSecureStorage();
  static const _key = 'alex_remote_saved_devices';

  Future<List<SavedDevice>> getDevices() async {
    final raw = await _storage.read(key: _key);

    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List;

    return decoded
        .map((item) => SavedDevice.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }

  Future<void> saveDevices(List<SavedDevice> devices) async {
    await _storage.write(
      key: _key,
      value: jsonEncode(
        devices.map((device) => device.toJson()).toList(),
      ),
    );
  }

  Future<void> addOrUpdate(SavedDevice device) async {
    final devices = await getDevices();

    final index = devices.indexWhere((d) => d.id == device.id);

    if (index == -1) {
      devices.add(device);
    } else {
      devices[index] = device;
    }

    await saveDevices(devices);
  }

  Future<void> delete(String id) async {
    final devices = await getDevices();
    devices.removeWhere((device) => device.id == id);
    await saveDevices(devices);
  }

  Future<void> rename(String id, String newName) async {
    final devices = await getDevices();

    final index = devices.indexWhere((d) => d.id == id);

    if (index == -1) return;

    devices[index] = devices[index].copyWith(name: newName);

    await saveDevices(devices);
  }

  Future<void> updateLastConnected(String id) async {
    final devices = await getDevices();

    final index = devices.indexWhere((d) => d.id == id);

    if (index == -1) return;

    devices[index] = devices[index].copyWith(
      lastConnectedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await saveDevices(devices);
  }
}
