import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MatchEmotionActivityScreen extends StatefulWidget {
  final String title; // Added to receive activity title
  final String skill; // Added to receive skill category

  const MatchEmotionActivityScreen({
    Key? key,
    required this.title,
    required this.skill,
  }) : super(key: key);

  @override
  _MatchEmotionActivityScreenState createState() =>
      _MatchEmotionActivityScreenState();
}

class _MatchEmotionActivityScreenState
    extends State<MatchEmotionActivityScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final FlutterTts flutterTts = FlutterTts();
  bool hasSpoken = false;

  final List<Map<String, dynamic>> questions = [
    {
      'emotion': 'Happy',
      'correct': 'assets/images/Happy Emotion.jpeg',
      'options': [
        'assets/images/Happy Emotion.jpeg',
        'assets/images/Sad Emotion.jpeg',
        'assets/images/Angry Emotion.jpeg',
        'assets/images/scared-kid.jpg',
      ],
    },
    {
      'emotion': 'Sad',
      'correct': 'assets/images/Sad Emotion.jpeg',
      'options': [
        'assets/images/Happy Emotion.jpeg',
        'assets/images/Angry Emotion.jpeg',
        'assets/images/Sad Emotion.jpeg',
        'assets/images/scared-kid.jpg',
      ],
    },
    {
      'emotion': 'Angry',
      'correct': 'assets/images/Angry Emotion.jpeg',
      'options': [
        'assets/images/Happy Emotion.jpeg',
        'assets/images/Sad Emotion.jpeg',
        'assets/images/scared-kid.jpg',
        'assets/images/Angry Emotion.jpeg',
      ],
    },
    {
      'emotion': 'Scared',
      'correct': 'assets/images/scared-kid.jpg',
      'options': [
        'assets/images/Happy Emotion.jpeg',
        'assets/images/Angry Emotion.jpeg',
        'assets/images/Sad Emotion.jpeg',
        'assets/images/scared-kid.jpg',
      ],
    },
  ];

  int currentQuestion = 0;
  int correctAnswers = 0;
  bool isAnswered = false;
  String selectedOption = '';
  bool showText = false;
  // Added to store responses for result dialog
  List<Map<String, dynamic>> responses = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        showText = true;
      });
    });
  }

  void playSound(bool correct) {
    final path =
        correct ? 'sounds/positive-answer.mp3' : 'sounds/wrong-answer.mp3';
    audioPlayer.play(AssetSource(path));
  }

  void playCompletionSound() {
    audioPlayer.play(AssetSource('sounds/cheer-up.mp3'));
  }

  void speakQuestion(String text) async {
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  // Removed restartActivity as it's no longer needed with new submission logic

  void checkAnswer(String option) {
    if (isAnswered) return;

    flutterTts.stop();

    final isCorrect = option == questions[currentQuestion]['correct'];

    setState(() {
      selectedOption = option;
      isAnswered = true;
      if (isCorrect) correctAnswers++;
      // Store response for result dialog
      responses.add({
        'expected': questions[currentQuestion]['emotion'],
        'selected': option,
        'status': isCorrect ? 'Correct' : 'Incorrect',
      });
    });

    playSound(isCorrect);
  }

  // Added to save score to database
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getInt('child_id');

    final correct = correctAnswers;
    final total = questions.length;

    await http.post(
      Uri.parse('http://192.168.1.10:8000/api/save-activity'),
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
    final correct = correctAnswers;
    final total = questions.length;

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
                              title: Text("Expected: ${entry['expected']}"),
                              subtitle: Text("Selected: ${entry['selected']}"),
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

  void nextQuestion() {
    flutterTts.stop();

    if (!isAnswered) return;

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        isAnswered = false;
        selectedOption = '';
        showText = false;
      });
      Future.delayed(Duration(milliseconds: 800), () {
        setState(() {
          showText = true;
        });
      });
    } else {
      playCompletionSound();
      _saveProgress(); // Save score to database
      _showResultDialog(); // Show results
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final emotion = question['emotion'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Use passed title
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// 👤 Head Character and Question Bubble
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
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child:
                        showText
                            ? AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Can you find the face showing $emotion emotion?',
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  speed: Duration(milliseconds: 30),
                                ),
                              ],
                              totalRepeatCount: 1,
                              onNextBeforePause: (int index, _) {
                                if (!hasSpoken) {
                                  hasSpoken = true;
                                  speakQuestion(
                                    'Can you find the face showing $emotion emotion?',
                                  );
                                }
                              },
                              onFinished: () {
                                hasSpoken = false;
                              },
                            )
                            : SizedBox(height: 20),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            /// 🖼 Image Tiles
            Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  children:
                      question['options'].map<Widget>((option) {
                        final isCorrect = option == question['correct'];
                        final isSelected = option == selectedOption;

                        return GestureDetector(
                          onTap: () => checkAnswer(option),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? (isCorrect
                                                ? Colors.green
                                                : Colors.red)
                                            : Colors.grey,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    option,
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
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color:
                                        isCorrect ? Colors.green : Colors.red,
                                    size: 28,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            /// ⏭ Next Button
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                  currentQuestion < questions.length - 1 ? "Next" : "Submit",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
