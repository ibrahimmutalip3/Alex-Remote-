
import 'package:flutter/material.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final addressController = TextEditingController();
  final portController = TextEditingController();
  final codeController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    portController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Widget inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 9),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
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
              'Pair your Android',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Enter the connection details shown in Android Wireless Debugging.',
              style: TextStyle(
                color: Colors.white54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            inputField(
              label: 'IP address',
              hint: '192.168.1.100',
              controller: addressController,
              keyboardType: TextInputType.url,
            ),

            const SizedBox(height: 20),

            inputField(
              label: 'Pairing port',
              hint: 'Example: 37000',
              controller: portController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            inputField(
              label: 'Pairing code',
              hint: 'Enter pairing code',
              controller: codeController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 32),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Connection is not implemented yet.',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8FF64),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Pair device',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
