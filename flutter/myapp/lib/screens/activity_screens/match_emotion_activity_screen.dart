// Adding if statement for completion and type writer style

// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class MatchEmotionActivityScreen extends StatefulWidget {
  @override
  _MatchEmotionActivityScreenState createState() =>
      _MatchEmotionActivityScreenState();
}

class _MatchEmotionActivityScreenState
    extends State<MatchEmotionActivityScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final FlutterTts flutterTts = FlutterTts();
  bool hasSpoken = false; // ✅ Correct location inside the State class

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
    // await flutterTts.setSpeechRate(0.5);
    // await flutterTts.speak(text);
    await flutterTts.stop(); // ⛔️ Cancel any ongoing speech
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text); // ✅ Speak immediately
  }

  // ✨ Added method to restart activity from the beginning
  void restartActivity() {
    setState(() {
      currentQuestion = 0;
      correctAnswers = 0;
      isAnswered = false;
      selectedOption = '';
      showText = false;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        showText = true;
      });
    });
  }

  void checkAnswer(String option) {
    if (isAnswered) return;

    flutterTts.stop(); // ✅ Cancel TTS if user selects an option early

    setState(() {
      selectedOption = option;
      isAnswered = true;
    });

    final isCorrect = option == questions[currentQuestion]['correct'];
    if (isCorrect) correctAnswers++;
    playSound(isCorrect);
  }

  void nextQuestion() {
    flutterTts.stop(); // ✅ Stop any ongoing TTS

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
      final allCorrect = correctAnswers == questions.length;
      if (allCorrect) {
        playCompletionSound(); // ✅ Only play if all answers are correct
      }

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(allCorrect ? "🎉 Great job!" : "Oops!"),
              content: Text(
                allCorrect
                    ? "You've completed the activity correctly!"
                    : "Please try again and choose the correct answers.",
              ),
              actions: [
                if (allCorrect)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // 👈 Go back to activity list
                    },
                    child: Text("Finish"),
                  ),
                if (!allCorrect)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      restartActivity(); // Retry if not all correct
                    },
                    child: Text("Retry"),
                  ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final emotion = question['emotion'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Match the Emotion"),
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
                                hasSpoken =
                                    false; // Reset so next question can speak again
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
                              // ✅ ✔️ Tick or ❌ Cross Icon (only show when selected)
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
                child: Text("Next"),
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
