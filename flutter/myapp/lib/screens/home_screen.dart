import 'package:flutter/material.dart';
import 'chat_screen.dart';
import '../widgets/app_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: SafeArea(
        child: Column(
          children: [
            // Updated AppHeader (already contains bigger Dashboard and icons above text)
            const AppHeader(title: 'Dashboard', showMenu: true, showParent: true),

            const Spacer(),

            // "HELLO I'M EDUBOT" image
            Image.asset('assets/HelloEDUBOT.png', height: 138),

            // Chatbot image
            Image.asset('assets/robot.png', height: 168, width: 168),

            const SizedBox(height: 20),

            // Greeting text
            const Text(
              'Nice to meet you! 😊\nHow can I help you?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const Spacer(),

            // Start Chatting Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                ),
                child: const Text("Let’s start chatting"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

