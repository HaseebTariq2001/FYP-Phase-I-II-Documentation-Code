import 'package:flutter/material.dart';
import 'dart:convert'; // For jsonEncode/jsonDecode
import 'package:http/http.dart' as http;

import '../models/message.dart';
import '../widgets/app_header.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(text: "Hello, How can I help you?", isUser: false),
  ];

  // ✅ Handle user message and get bot reply from API
  Future<void> _handleSend(String input) async {
    setState(() {
      _messages.add(Message(text: input, isUser: true));
    });

    try {
      final response = await http.post(
        // Uri.parse('http://100.64.40.119:8000/chat'), // (mob_emulator)
        Uri.parse('http://192.168.1.6:8000/chat'), //(chrome)
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': input}),
      );

      if (response.statusCode == 200) {
        final botReply = jsonDecode(response.body)['reply'];
        setState(() {
          _messages.add(Message(text: botReply, isUser: false));
        });
      } else {
        setState(() {
          _messages.add(
            Message(text: 'Bot error: ${response.statusCode}', isUser: false),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message(text: 'Error: $e', isUser: false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            const AppHeader(title: 'EduBot', showBack: true),

            // Chat area
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Opacity(
                      opacity: 0.40,
                      child: Image.asset(
                        'assets/robot.png',
                        width: 170,
                        height: 170,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: _messages.length,
                          itemBuilder:
                              (_, index) =>
                                  MessageBubble(message: _messages[index]),
                        ),
                      ),
                      ChatInput(onSend: _handleSend),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
