
import 'package:flutter/material.dart';
import '../services/remote_device_service.dart';

class RemoteControlScreen extends StatefulWidget {
  final RemoteDeviceService device;
  final String deviceName;

  const RemoteControlScreen({
    super.key,
    required this.device,
    required this.deviceName,
  });

  @override
  State<RemoteControlScreen> createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends State<RemoteControlScreen> {
  bool busy = false;
  String status = 'Connected';

  Future<void> send(String key) async {
    if (busy) return;

    setState(() {
      busy = true;
      status = 'Sending...';
    });

    try {
      await widget.device.execute('input keyevent $key');
      if (!mounted) return;
      setState(() => status = 'Command sent');
    } catch (e) {
      if (!mounted) return;
      setState(() => status = 'Error: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget control(String label, String key, {IconData? icon}) {
    return SizedBox(
      width: 72,
      height: 64,
      child: ElevatedButton(
        onPressed: busy ? null : () => send(key),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF202023),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: EdgeInsets.zero,
        ),
        child: icon == null ? Text(label) : Icon(icon, size: 27),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deviceName),
        actions: [
          IconButton(
            icon: const Icon(Icons.link_off),
            onPressed: () async {
              await widget.device.disconnect();
              if (mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.circle,
                      color: Color(0xFFD8FF64), size: 9),
                  const SizedBox(width: 9),
                  Expanded(child: Text(widget.deviceName)),
                  const Text(
                    'ONLINE',
                    style: TextStyle(color: Color(0xFFD8FF64)),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'NAVIGATION',
                style: TextStyle(
                  color: Colors.white38,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              control('Up', 'KEYCODE_DPAD_UP',
                  icon: Icons.keyboard_arrow_up),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  control('Left', 'KEYCODE_DPAD_LEFT',
                      icon: Icons.keyboard_arrow_left),
                  const SizedBox(width: 10),
                  control('OK', 'KEYCODE_DPAD_CENTER'),
                  const SizedBox(width: 10),
                  control('Right', 'KEYCODE_DPAD_RIGHT',
                      icon: Icons.keyboard_arrow_right),
                ],
              ),
              const SizedBox(height: 10),
              control('Down', 'KEYCODE_DPAD_DOWN',
                  icon: Icons.keyboard_arrow_down),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  control('Back', 'KEYCODE_BACK'),
                  control('Home', 'KEYCODE_HOME'),
                  control('Recent', 'KEYCODE_APP_SWITCH'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  control('Vol −', 'KEYCODE_VOLUME_DOWN'),
                  control('Vol +', 'KEYCODE_VOLUME_UP'),
                  control('Power', 'KEYCODE_POWER'),
                ],
              ),
              const Spacer(),
              Text(status,
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }
}
