
import 'package:flutter/material.dart';
import '../services/remote_device_service.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final address = TextEditingController();
  final pairingPort = TextEditingController();
  final pairingCode = TextEditingController();
  final connectPort = TextEditingController();

  final device = RemoteDeviceService();

  bool busy = false;
  bool paired = false;
  bool connected = false;
  String status = 'Not connected';

  @override
  void dispose() {
    address.dispose();
    pairingPort.dispose();
    pairingCode.dispose();
    connectPort.dispose();
    super.dispose();
  }

  int? readPort(TextEditingController controller) {
    final value = int.tryParse(controller.text.trim());
    if (value == null || value < 1 || value > 65535) return null;
    return value;
  }

  Future<void> pairDevice() async {
    final host = address.text.trim();
    final port = readPort(pairingPort);
    final code = pairingCode.text.trim();

    if (host.isEmpty || port == null || code.length != 6) {
      setState(() => status = 'Enter IP, pairing port and 6-digit code.');
      return;
    }

    setState(() {
      busy = true;
      status = 'Pairing...';
    });

    try {
      final result = await device.pair(
        host: host,
        pairingPort: port,
        code: code,
      );

      if (!mounted) return;
      setState(() {
        paired = result;
        status = result
            ? 'Pairing successful. Enter the ADB connection port.'
            : 'Pairing failed. Check the code and port.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => status = 'Pairing error: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> connectDevice() async {
    final host = address.text.trim();
    final port = readPort(connectPort);

    if (host.isEmpty || port == null) {
      setState(() => status = 'Enter a valid IP and ADB port.');
      return;
    }

    setState(() {
      busy = true;
      status = 'Connecting...';
    });

    try {
      final result = await device.connect(host: host, port: port);

      if (!mounted) return;
      setState(() {
        connected = result;
        status = result
            ? 'Connected to Android.'
            : 'Connection failed. Check the ADB port.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => status = 'Connection error: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> disconnectDevice() async {
    await device.disconnect();
    if (!mounted) return;
    setState(() {
      connected = false;
      status = 'Disconnected.';
    });
  }

  Widget input({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 9),
        TextField(
          controller: controller,
          keyboardType: type,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30),
            filled: true,
            fillColor: const Color(0xFF171719),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget action(String label, VoidCallback callback) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: busy ? null : callback,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD8FF64),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0D),
        title: const Text('Connect device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Icon(
              Icons.phone_android_rounded,
              color: Color(0xFFD8FF64),
              size: 48,
            ),
            const SizedBox(height: 20),
            const Text(
              'Samsung Galaxy A12',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Both devices must be on the same Wi-Fi network during pairing.',
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 28),
            input(
              label: 'IP address',
              hint: '192.168.1.100',
              controller: address,
              type: TextInputType.url,
            ),
            const SizedBox(height: 24),
            const Text(
              '1. Wireless debugging pairing',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            input(
              label: 'Pairing port',
              hint: 'Pair device with pairing code',
              controller: pairingPort,
              type: TextInputType.number,
            ),
            const SizedBox(height: 18),
            input(
              label: '6-digit pairing code',
              hint: '123456',
              controller: pairingCode,
              type: TextInputType.number,
            ),
            const SizedBox(height: 14),
            action(busy ? 'Please wait...' : 'Pair device', pairDevice),
            const SizedBox(height: 28),
            const Text(
              '2. ADB connection',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            input(
              label: 'ADB connection port',
              hint: 'Port on Wireless debugging screen',
              controller: connectPort,
              type: TextInputType.number,
            ),
            const SizedBox(height: 14),
            action(busy ? 'Please wait...' : 'Connect', connectDevice),
            if (connected) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: busy ? null : disconnectDevice,
                child: const Text('Disconnect'),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              status,
              style: TextStyle(
                color: connected
                    ? const Color(0xFFD8FF64)
                    : Colors.white70,
              ),
            ),
            if (paired) ...[
              const SizedBox(height: 8),
              const Text(
                'Pairing completed.',
                style: TextStyle(color: Color(0xFFD8FF64)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
