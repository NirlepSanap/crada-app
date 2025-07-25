import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'otp_verification_screen.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isPhoneFocused = false;
  String _completePhoneNumber = ''; // <-- required for OTP screen

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      setState(() {
        _isPhoneFocused = _phoneFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Step progress bar
                SizedBox(
                  height: 6,
                  child: Stack(
                    children: [
                      Container(width: double.infinity, color: Colors.grey[300]),
                      FractionallySizedBox(
                        widthFactor: 0.20,
                        child: Container(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Title that changes
                Text(
                  _isPhoneFocused ? 'Sign in' : 'Getting Started',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 24),

                // Phone Number Input
                IntlPhoneField(
                  focusNode: _phoneFocusNode,
                  initialCountryCode: 'IN',
                  decoration: InputDecoration(
                    hintText: 'Enter Phone Number',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (phone) {
                    setState(() {
                      _completePhoneNumber = phone.completeNumber;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Send OTP Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_completePhoneNumber.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OTPVerificationScreen(
                              phoneNumber: _completePhoneNumber, verificationId: '',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter a valid phone number")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPhoneFocused ? const Color(0xFF4C4C4C) : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send OTP',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (!_isPhoneFocused)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to Sign In screen
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 40),

                const Text(
                  "Or Continue with:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF4C4C4C)),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIconButton('assets/google.png', () {
                      // TODO: Google sign-in logic
                    }),
                    const SizedBox(width: 16),
                    _socialIconButton('assets/apple.png', () {
                      // TODO: Apple sign-in logic
                    }),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialIconButton(String iconPath, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(iconPath, fit: BoxFit.contain),
      ),
    );
  }
}
