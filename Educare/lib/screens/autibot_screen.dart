import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AutibotScreen extends StatefulWidget {
  @override
  _AutibotScreenState createState() => _AutibotScreenState();
}

class _AutibotScreenState extends State<AutibotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];

  void sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;

      setState(() {
        messages.add({"sender": "user", "text": userMessage});
      });

      _controller.clear();

      // Scroll to bottom after sending a message
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });

      try {
        // Send the message to your Flask backend (ensure the Flask server is running)
        final response = await http.post(
          Uri.parse("http://192.168.10.7:5000/predict"), // Update with your local IP
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"question": userMessage}), // Send the question key to Flask
        );

        if (response.statusCode == 200) {
          // If the response is successful, parse the bot's reply
          final botReply = jsonDecode(response.body)["prediction"];

          setState(() {
            messages.add({"sender": "bot", "text": botReply});
          });
        } else {
          // If an error occurred, show the error code
          setState(() {
            messages.add({"sender": "bot", "text": "Bot error: ${response.statusCode}"});
          });
        }
      } catch (e) {
        // Handle error if unable to reach the Flask server
        setState(() {
          messages.add({"sender": "bot", "text": "Error: Could not reach server."});
        });
      }

      // Scroll again after the bot responds
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AutiBot"),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.blue.shade800,
            child: Column(
              children: [
                Text(
                  "HELLO, I'M AutiBOT 🤖",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  "Nice to meet you! How can I help?",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messages[index]["text"]!,
                      style: TextStyle(fontSize: 16, color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage, // Call sendMessage when button is pressed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
