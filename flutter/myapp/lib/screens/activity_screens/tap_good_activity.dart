import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';

class TapGoodBehaviorActivityScreen extends StatefulWidget {
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
  int correctAnswers = 0;
  List<bool> screenCompletedCorrectly = [];

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

  List<int> selectedIndexes = [];

  @override
  void initState() {
    super.initState();
    screenCompletedCorrectly = List.filled(screens.length, false);
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
    });
  }

  void goToNextScreen() {
    final options = screens[currentScreen]["options"];
    final correctIndexes =
        options
            .asMap()
            .entries
            .where((entry) => entry.value["isGood"] == true)
            .map((entry) => entry.key)
            .toList();

    final allCorrectTapped = correctIndexes.every(
      (index) => selectedIndexes.contains(index),
    );
    final anyWrongTapped = selectedIndexes.any(
      (index) => options[index]["isGood"] == false,
    );

    if (allCorrectTapped && !anyWrongTapped) {
      correctAnswers++;
      screenCompletedCorrectly[currentScreen] = true;
    }

    flutterTts.stop();

    if (currentScreen < screens.length - 1) {
      setState(() {
        currentScreen++;
        selectedIndexes.clear();
        hasSpoken = false;
      });
    } else {
      bool allCorrect = screenCompletedCorrectly.every((c) => c);
      if (allCorrect) playCompletionSound();

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(allCorrect ? "🎉 Great job!" : "Try Again"),
              content: Text(
                allCorrect
                    ? "You tapped all the good behaviors correctly!"
                    : "Oops! You missed some good behaviors.",
              ),
              actions: [
                if (allCorrect)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Finish"),
                  ),
                if (!allCorrect)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        currentScreen = 0;
                        selectedIndexes.clear();
                        hasSpoken = false;
                        correctAnswers = 0;
                        screenCompletedCorrectly = List.filled(
                          screens.length,
                          false,
                        );
                      });
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
    final screen = screens[currentScreen];
    final question = screen["question"];

    return Scaffold(
      appBar: AppBar(
        title: Text("Tap the Good Behavior"),
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
                Image.asset('assets/images/question-ask.png', width: 60, height: 60),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AnimatedTextKit(
                      key: ValueKey(currentScreen), // 👈 Fix for TTS
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
            Builder(
              builder: (context) {
                final options = screen["options"];
                final correctIndexes =
                    options
                        .asMap()
                        .entries
                        .where((entry) => entry.value["isGood"] == true)
                        .map((entry) => entry.key)
                        .toList();

                final allCorrectTapped = correctIndexes.every(
                  (index) => selectedIndexes.contains(index),
                );
                final anyWrongTapped = selectedIndexes.any(
                  (index) => options[index]["isGood"] == false,
                );
                final canProceed = allCorrectTapped && !anyWrongTapped;

                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: canProceed ? () => goToNextScreen() : null,
                    icon: Icon(Icons.arrow_forward),
                    label: Text("Next"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canProceed ? Colors.orangeAccent : Colors.grey,
                      padding: EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 12,
                      ),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
