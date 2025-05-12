import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TapGoodBehaviorActivityScreen extends StatefulWidget {
  final String title; // Added to receive activity title
  final String skill; // Added to receive skill category

  const TapGoodBehaviorActivityScreen({
    Key? key,
    required this.title,
    required this.skill,
  }) : super(key: key);

  @override
  State<TapGoodBehaviorActivityScreen> createState() =>
      _TapGoodBehaviorActivityScreenState();
}

class _TapGoodBehaviorActivityScreenState
    extends State<TapGoodBehaviorActivityScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool hasSpoken = false;

  int currentScreen = 0;
  List<Map<String, dynamic>> responses = []; // Added to store responses
  List<int> selectedIndexes = [];

  final List<Map<String, dynamic>> screens = [
    {
      "question": "Which of these shows good behavior?",
      "options": [
        {"image": "assets/images/sharing-toy.jpeg", "isGood": true},
        {"image": "assets/images/grabbing-toy.jpeg", "isGood": false},
        {"image": "assets/images/yelling-kid.jpeg", "isGood": false},
        {"image": "assets/images/playing-nicely.jpeg", "isGood": true},
      ],
    },
    {
      "question": "Tap all good behaviors.",
      "options": [
        {"image": "assets/images/ignoring-child.jpg", "isGood": false},
        {"image": "assets/images/helping-book.jpeg", "isGood": true},
        {"image": "assets/images/helping-child.jpeg", "isGood": true},
        {"image": "assets/images/laughing-someone.jpeg", "isGood": false},
      ],
    },
    {
      "question": "Find only the good Classroom Manners.",
      "options": [
        {"image": "assets/images/teacher-teaching.jpg", "isGood": false},
        {"image": "assets/images/ask-question.jpeg", "isGood": true},
        {"image": "assets/images/throwing-paper.jpg", "isGood": false},
        {"image": "assets/images/sitting-attentive.jpg", "isGood": true},
      ],
    },
    {
      "question": "Tap the good Playground Etiquette.",
      "options": [
        {"image": "assets/images/turn-wait.jpg", "isGood": true},
        {"image": "assets/images/pushing-kid.jpg", "isGood": false},
        {"image": "assets/images/kid-climb.jpg", "isGood": true},
        {"image": "assets/images/running-away.jpg", "isGood": false},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Removed screenCompletedCorrectly as it's no longer needed
    speak(screens[currentScreen]["question"]); // Speak initial question
  }

  void speak(String text) async {
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void playSound(bool correct) {
    final path =
        correct ? 'sounds/positive-answer.mp3' : 'sounds/wrong-answer.mp3';
    audioPlayer.play(AssetSource(path));
  }

  void playCompletionSound() {
    audioPlayer.play(AssetSource('sounds/cheer-up.mp3'));
  }

  void selectOption(int index) {
    if (selectedIndexes.contains(index)) return;

    final isGood = screens[currentScreen]["options"][index]["isGood"];
    playSound(isGood);

    setState(() {
      selectedIndexes.add(index);
      // Store response
      responses.add({
        'screen': screens[currentScreen]["question"],
        'image': screens[currentScreen]["options"][index]["image"],
        'isGood': isGood,
        'status': isGood ? 'Correct' : 'Incorrect',
      });
    });
  }

  // Added to save score to database
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getInt('child_id');

    final correct = responses.where((r) => r['status'] == 'Correct').length;
    final total = responses.length;

    await http.post(
      Uri.parse('http://192.168.1.6:8000/api/save-activity'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'child_id': childId,
        'activity_name': widget.title,
        'skill_category': widget.skill,
        'correct_phrases': correct,
        'total_phrases': total,
      }),
    );
  }

  // Added to show result dialog
  void _showResultDialog() {
    final correct = responses.where((r) => r['status'] == 'Correct').length;
    final total = responses.length;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Activity Completed!"),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Score: $correct / $total",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: ListView(
                      shrinkWrap: true,
                      children:
                          responses.map((entry) {
                            return ListTile(
                              leading: Icon(
                                entry['status'] == 'Correct'
                                    ? Icons.check
                                    : Icons.close,
                                color:
                                    entry['status'] == 'Correct'
                                        ? Colors.green
                                        : Colors.red,
                              ),
                              title: Text("Screen: ${entry['screen']}"),
                              subtitle: Text(
                                "Image: ${entry['image'].split('/').last}",
                              ),
                              trailing: Text(entry['status']),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Done"),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, 'completed'); // Signal completion
                },
              ),
            ],
          ),
    );
  }

  void goToNextScreen() {
    flutterTts.stop();

    if (currentScreen < screens.length - 1) {
      setState(() {
        currentScreen++;
        selectedIndexes.clear();
        hasSpoken = false;
      });
    } else {
      playCompletionSound();
      _saveProgress(); // Save score
      _showResultDialog(); // Show results
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = screens[currentScreen];
    final question = screen["question"];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Use passed title
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// 👤 Head + Animated Question
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/question-ask.png',
                  width: 60,
                  height: 60,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AnimatedTextKit(
                      key: ValueKey(currentScreen),
                      animatedTexts: [
                        TypewriterAnimatedText(
                          question,
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          speed: Duration(milliseconds: 30),
                        ),
                      ],
                      totalRepeatCount: 1,
                      onNextBeforePause: (index, _) {
                        if (!hasSpoken) {
                          hasSpoken = true;
                          speak(question);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            /// 🖼 Image Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: List.generate(screen["options"].length, (index) {
                  final option = screen["options"][index];
                  final isSelected = selectedIndexes.contains(index);
                  final isCorrect = option["isGood"];

                  return GestureDetector(
                    onTap: () => selectOption(index),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected
                                      ? (isCorrect ? Colors.green : Colors.red)
                                      : Colors.grey,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              option["image"],
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                              size: 28,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            /// ✅ Next Button
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton.icon(
                onPressed:
                    selectedIndexes.isNotEmpty
                        ? () => goToNextScreen()
                        : null, // Enable Next if any selection made
                icon: Icon(Icons.arrow_forward),
                label: Text("Next"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedIndexes.isNotEmpty
                          ? Colors.orangeAccent
                          : Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    audioPlayer.dispose();
    super.dispose();
  }
}
