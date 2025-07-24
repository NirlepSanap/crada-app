import 'package:flutter/material.dart';
import 'splash/splash_screen.dart';
// import 'dashboard/main_dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
     // home: MainDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}