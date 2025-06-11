import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> submitFeedback() async {
    String message = _messageController.text;

    // Check if the message is empty
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a feedback message.")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // API endpoint (replace this with your actual backend URL)
    var url = Uri.parse(
      'https://educare-backend-9nb1.onrender.com/submit_feedback',
    );

    try {
      // Send POST request to the backend with message
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'message': message}),
      );

      var responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['status'] == 'success') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(responseBody['message'])));
        _messageController
            .clear(); // Clear the text field after successful submission
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['message'] ?? 'Failed to submit feedback',
            ),
          ),
        );
      }
    } catch (e) {
      // Handle errors (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error submitting feedback.")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // backgroundColor: Color.fromARGB(
        //   255,
        //   161,
        //   129,
        //   216,
        // ), // Set the AppBar background to purple
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white), // added for icon
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your feedback below:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Write your message here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : submitFeedback,
                child:
                    _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit Feedback"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
