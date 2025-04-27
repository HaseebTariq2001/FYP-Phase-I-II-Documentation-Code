import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;

  const ChatInput({super.key, required this.onSend});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.blue[800],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
         
          IconButton(
              onPressed: _send,
              icon: SvgPicture.asset(
                'assets/paper-plane-solid.svg',
                height: 30,
                width: 35,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
          )
        ],
      ),
    );
  }
}
