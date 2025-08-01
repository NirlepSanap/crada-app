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
    setState(() => isPressed = true);
    Future.delayed(const Duration(milliseconds: 150), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GettingStartedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Curved Header
              ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  color: const Color(0xFF4C4C4C),
                  padding: const EdgeInsets.only(top: 60, bottom: 100),
                  child: Center(
                    child: Image.asset(
                      'assets/logo_light.png',
                      width: 220,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // Create Account Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 48,
                  decoration: BoxDecoration(
                    color: isPressed ? const Color(0xFF4C4C4C) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                  ),
                  child: OutlinedButton(
                    onPressed: _handleButtonPress,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: isPressed ? Colors.white : Colors.black,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 120),

              // Footer Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          'Content Policy',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
