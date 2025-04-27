import 'package:flutter/material.dart';
import 'home_Screen.dart'; // Import your Parent Dashboard Screen

class ResultScreen extends StatefulWidget {
  final String result;
  final String childName; // 🆕 Add this

  const ResultScreen({
    super.key,
    required this.result,
    required this.childName, // 🆕 Add this to the constructor
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for the fade-in effect
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Start the animation
    _controller.forward();
  }

  // Function to determine the color of the result based on the score
  Color getResultColor(String result) {
    if (result.contains('Low') || result.contains('Positive')) {
      return Colors.green; // Positive result
    } else if (result.contains('Moderate') || result.contains('Neutral')) {
      return Colors.yellow[700]!; // Neutral result (with darker yellow)
    } else {
      return Colors.red; // Negative result
    }
  }

  // Function to determine the icon based on the result
  Icon getResultIcon(String result) {
    if (result.contains('Low') || result.contains('Positive')) {
      return Icon(Icons.check_circle, color: Colors.green, size: 50);
    } else if (result.contains('Moderate') || result.contains('Neutral')) {
      return Icon(Icons.info, color: Colors.yellow[700], size: 50);
    } else {
      return Icon(Icons.cancel, color: Colors.red, size: 50);
    }
  }

  // Function to determine the text color based on the background color for readability
  Color getTextColor(String result) {
    // Always use dark color (black or dark grey) for text for readability
    if (result.contains('Low') || result.contains('Positive')) {
      return Colors.black; // Positive result - black text
    } else if (result.contains('Moderate') || result.contains('Neutral')) {
      return Colors.black; // Neutral result - black text
    } else {
      return Colors.white; // Negative result - white text for contrast
    }
  }

  // Capitalize function
  String capitalize(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  String extractScore(String result) {
    final match = RegExp(r'score\s*:\s*(\d+)').firstMatch(result.toLowerCase());
    return match != null ? match.group(1)! : "N/A";
  }

  @override
  Widget build(BuildContext context) {
    // Extract severity and score safely
    String severity =
        widget.result.contains('severity')
            ? widget.result.split('severity:')[1].split(',')[0].trim()
            : "Unknown";

    String score = extractScore(widget.result);
    String childName = capitalize(widget.childName);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Center(
          child: Text(
            "Assessment Result",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Result Card
            FadeTransition(
              opacity: _opacity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                color: getResultColor(severity).withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      getResultIcon(severity),
                      SizedBox(height: 20),
                      Text(
                        "$childName has $severity",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: getTextColor(severity),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Score: $score",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: getTextColor(severity),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(Icons.dashboard_customize, size: 26),
              label: Text(
                "Go to Dashboard",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
