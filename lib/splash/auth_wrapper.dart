import 'package:cradius_app/dashboard/main_dashboard_screen.dart';
import 'package:cradius_app/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return MainDashboardScreen(); // user is signed in
        }
        return SplashScreen(); // user is not signed in
      },
    );
  }
}
