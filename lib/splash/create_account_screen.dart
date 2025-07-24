import 'package:cradius_app/splash/create_account_screen.dart';
import 'package:cradius_app/splash/getting_started_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CradiusApp());
}

class CradiusApp extends StatelessWidget {
  const CradiusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cradius',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const CreateAccountScreen(),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool isPressed = false;

  void _handleButtonPress() {
    setState(() {
      isPressed = true;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GettingStartedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Curved Header
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              color: const Color(0xFF4C4C4C),
              padding: const EdgeInsets.only(top: 80, bottom: 120),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo_light.png',
                    width: 300,
                    height: 200,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 100),

          // Create Account Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _handleButtonPress,
                style: OutlinedButton.styleFrom(
                  backgroundColor: isPressed ? const Color(0xFF4C4C4C) : Colors.white,
                  foregroundColor: isPressed ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.black),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Footer Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                const Text(
                  'By continuing you agree to our',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: const [
                    Text(
                      'Terms of Service',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          decoration: TextDecoration.underline),
                    ),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          decoration: TextDecoration.underline),
                    ),
                    Text(
                      'Content Policy',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


// Curved clipper
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}