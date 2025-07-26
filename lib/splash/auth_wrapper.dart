import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_account_screen.dart';
import 'business_info_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return BusinessInfoScreen(); // Authenticated
        } else {
          return CreateAccountScreen(); // Not logged in
        }
      },
    );
  }
}
