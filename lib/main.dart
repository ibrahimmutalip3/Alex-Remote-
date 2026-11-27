
import 'package:flutter/material.dart';
import 'screens/connect_screen.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
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
                'Remote control.',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Control your Android device remotely.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF171719),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.phone_android_rounded,
                      size: 32,
                      color: Color(0xFFD8FF64),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Samsung Galaxy A12',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.orange,
                          size: 9,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Not connected',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConnectScreen(),
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
                          'Connect device',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
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
