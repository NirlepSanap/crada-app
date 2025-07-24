import 'package:flutter/material.dart';
import 'business_info_screen.dart'; 

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: const [
                  LinearProgressIndicator(
                    value: 0.8,
                    color: Colors.black,
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'We ask for your personal information to verify your identity',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField('First Name', firstNameController),
            const SizedBox(height: 16),
            _buildTextField('Last Name', lastNameController),
            const SizedBox(height: 16),
            _buildTextField('Email', emailController),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isButtonPressed = true;
                  });
                },
                onTapUp: (_) async {
                  await Future.delayed(const Duration(milliseconds: 100));
                  setState(() {
                    isButtonPressed = false;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BusinessInfoScreen()),
                  );
                },
                onTapCancel: () {
                  setState(() {
                    isButtonPressed = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isButtonPressed ? Colors.black : Colors.white,
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: isButtonPressed ? Colors.white : Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
