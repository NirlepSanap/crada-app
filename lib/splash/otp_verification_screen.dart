import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// ✅ Import your next screen
import 'personal_info_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String _otpCode = '';
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              // Progress Bar
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  child: LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Title
              const Center(
                child: Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Subtext with masked number
              Center(
                child: Text(
                  "We’ve sent the code to ${_maskPhone(widget.phoneNumber)}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 32),

              // OTP Input
              PinCodeTextField(
                appContext: context,
                length: 4,
                onChanged: (value) => setState(() => _otpCode = value),
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 60,
                  fieldWidth: 60,
                  activeColor: Colors.grey.shade600,
                  selectedColor: Colors.black,
                  inactiveColor: Colors.grey.shade300,
                ),
              ),

              const SizedBox(height: 12),

              // Resend OTP
              const Center(
                child: Text(
                  "Resend",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const Spacer(),

              // Arrow Button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTapDown: (_) {
                    if (_otpCode.length == 4) {
                      setState(() => _isPressed = true);
                    }
                  },
                  onTapUp: (_) {
                    if (_otpCode.length == 4) {
                      setState(() => _isPressed = false);

                      // ✅ Show feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("OTP Verified!")),
                      );

                      // ✅ Navigate to next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PersonalInfoScreen(),
                        ),
                      );
                    }
                  },
                  onTapCancel: () => setState(() => _isPressed = false),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _isPressed ? Colors.black : Colors.transparent,
                      border: Border.all(
                        color: _otpCode.length == 4 ? Colors.black : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: _isPressed
                          ? Colors.white
                          : (_otpCode.length == 4 ? Colors.black : Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to mask phone number
  static String _maskPhone(String number) {
    if (number.length < 4) return "****";
    return '****${number.substring(number.length - 3)}';
  }
}
