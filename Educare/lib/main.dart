import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Educare/screens/splash_screen.dart';
import 'package:Educare/screens/create_account_screen.dart';
import 'package:Educare/screens/login_screen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();// Initialize Firebase before running the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Educare',
      home: SplashScreen(), // Start from Splash Screen
      routes: {
        '/create_account': (context) => CreateAccountScreen(),
        '/login': (context) => LoginScreen(), // Add Login Screen Route
      },
    );
  }
}
