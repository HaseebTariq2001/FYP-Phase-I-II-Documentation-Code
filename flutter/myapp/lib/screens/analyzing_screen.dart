import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnalyzingScreen extends StatelessWidget {
  const AnalyzingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/Analyzing.json',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              "Analyzing Assessment...",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Please wait a moment",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
