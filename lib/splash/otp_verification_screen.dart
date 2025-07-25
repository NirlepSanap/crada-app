import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'personal_info_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber, required String verificationId});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String _otpCode = '';
  String _verificationId = '';
  bool _isPressed = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sendOTP();
  }

  // ✅ Send OTP
  Future<void> _sendOTP() async {
    setState(() => _isLoading = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.phoneNumber}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification Failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // ✅ Verify OTP
  Future<void> _verifyOTP() async {
    setState(() => _isLoading = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Verified!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
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
              const Center(
                child: Text(
                  'Enter OTP',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "We’ve sent the code to ${_maskPhone(widget.phoneNumber)}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 32),
              PinCodeTextField(
                appContext: context,
                length: 6,
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
              GestureDetector(
                onTap: _sendOTP,
                child: const Center(
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
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTapDown: (_) {
                    if (_otpCode.length == 6) {
                      setState(() => _isPressed = true);
                    }
                  },
                  onTapUp: (_) {
                    if (_otpCode.length == 6) {
                      setState(() => _isPressed = false);
                      _verifyOTP();
                    }
                  },
                  onTapCancel: () => setState(() => _isPressed = false),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _isPressed ? Colors.black : Colors.transparent,
                      border: Border.all(
                        color: _otpCode.length == 6 ? Colors.black : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(
                            Icons.arrow_forward,
                            color: _isPressed
                                ? Colors.white
                                : (_otpCode.length == 6 ? Colors.black : Colors.grey),
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

  static String _maskPhone(String number) {
    if (number.length < 4) return "****";
    return '****${number.substring(number.length - 3)}';
  }
}
