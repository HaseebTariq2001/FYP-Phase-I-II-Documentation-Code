import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue[700] : Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: message.isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
