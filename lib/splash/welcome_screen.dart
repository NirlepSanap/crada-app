import 'package:flutter/material.dart';
import 'package:cradius_app/dashboard/main_dashboard_screen.dart'; // Import your main dashboard screen

class WelcomeScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  
  const WelcomeScreen({
    super.key,
    this.userData,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainDashboardScreen(userData: widget.userData),
        ),
      );
    });
  }

  String _getUserName() {
    if (widget.userData != null) {
      String firstName = widget.userData!['firstName'] ?? '';
      String lastName = widget.userData!['lastName'] ?? '';
      
      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        return '$firstName $lastName';
      } else if (firstName.isNotEmpty) {
        return firstName;
      } else if (lastName.isNotEmpty) {
        return lastName;
      }
    }
    return 'LazyDevloper'; // Fallback to original text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C5C5C),
      body: Center(
        child: Text(
          'Welcome, ${_getUserName()}!',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}