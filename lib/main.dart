
import 'package:flutter/material.dart';

import 'models/saved_device.dart';
import 'screens/connect_screen.dart';
import 'screens/remote_control_screen.dart';
import 'services/remote_device_service.dart';
import 'services/saved_device_store.dart';

void main() {
  runApp(const AlexRemoteApp());
}

class AlexRemoteApp extends StatelessWidget {
  const AlexRemoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alex Remote',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B0D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD8FF64),
          surface: Color(0xFF171719),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final store = SavedDeviceStore();

  List<SavedDevice> devices = [];
  bool loading = true;
  String? connectingId;
  String status = '';

  @override
  void initState() {
    super.initState();
    loadDevices(autoConnect: true);
  }

  Future<void> loadDevices({bool autoConnect = false}) async {
    final result = await store.getDevices();

    if (!mounted) return;

    setState(() {
      devices = result;
      loading = false;
    });

    if (autoConnect && result.isNotEmpty) {
      final sorted = [...result]
        ..sort((a, b) =>
            (b.lastConnectedAt ?? 0).compareTo(a.lastConnectedAt ?? 0));

      connectDevice(sorted.first, automatic: true);
    }
  }

  Future<void> addDevice() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ConnectScreen(),
      ),
    );

    await loadDevices();
  }

  Future<void> connectDevice(
    SavedDevice saved, {
    bool automatic = false,
  }) async {
    if (connectingId != null) return;

    setState(() {
      connectingId = saved.id;
      status = automatic ? 'Restoring connection...' : 'Connecting...';
    });

    final service = RemoteDeviceService();

    try {
      final connected = await service.connect(
        host: saved.host,
        port: saved.port,
      );

      if (!mounted) {
        await service.disconnect();
        return;
      }

      if (!connected) {
        setState(() {
          connectingId = null;
          status = 'Could not connect to ${saved.name}.';
        });
        return;
      }

      await store.updateLastConnected(saved.id);

      if (!mounted) return;

      setState(() {
        connectingId = null;
        status = '';
      });

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RemoteControlScreen(
            device: service,
            deviceName: saved.name,
          ),
        ),
      );

      if (mounted) {
        await loadDevices();
      }
    } catch (e) {
      await service.disconnect();

      if (!mounted) return;

      setState(() {
        connectingId = null;
        status = 'Connection failed: $e';
      });
    }
  }

  Future<void> renameDevice(SavedDevice device) async {
    final controller = TextEditingController(text: device.name);

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF202023),
        title: const Text('Rename device'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Device name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (name == null || name.isEmpty) return;

    await store.rename(device.id, name);
    await loadDevices();
  }

  Future<void> deleteDevice(SavedDevice device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF202023),
        title: const Text('Delete device?'),
        content: Text('Remove "${device.name}" from your device list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await store.delete(device.id);
    await loadDevices();
  }

  Widget deviceCard(SavedDevice device) {
    final isConnecting = connectingId == device.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: const Color(0xFF171719),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.phone_android_rounded,
                color: Color(0xFFD8FF64),
                size: 30,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${device.host}:${device.port}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: const Color(0xFF252529),
                onSelected: (value) {
                  if (value == 'rename') renameDevice(device);
                  if (value == 'delete') deleteDevice(device);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'rename',
                    child: Text('Rename'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: connectingId == null
                  ? () => connectDevice(device)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD8FF64),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                isConnecting ? 'Connecting...' : 'Connect',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'ALEX REMOTE',
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 3,
                  color: Color(0xFFD8FF64),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your devices.',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage and connect your Android devices.',
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : devices.isEmpty
                        ? const Center(
                            child: Text(
                              'No devices added yet.',
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        : ListView(
                            children: devices.map(deviceCard).toList(),
                          ),
              ),
              if (status.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: connectingId == null ? addDevice : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Add new device'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8FF64),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'ALEX REMOTE • VERSION 1.0',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
