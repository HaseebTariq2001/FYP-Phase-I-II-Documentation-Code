import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'package:myapp/services/notification_service.dart';        // ✅ NEW: add this
import 'package:myapp/utils/preferences_helper.dart';   

class LessonScreen extends StatefulWidget {
  final List<String> phrases;
  final String title;
  final int lessonIndex;
  final int totalLessonCount;

  const LessonScreen({
    super.key,
    required this.phrases,
    required this.title,
    required this.lessonIndex,
    required this.totalLessonCount,
  });

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText speechToText = SpeechToText();
  final Random _random = Random();
  final AudioPlayer audioPlayer = AudioPlayer();

  int currentIndex = 0;
  String childResponse = "";
  String praiseText = "";
  String praiseEmoji = "";
  int correctCount = 0;
  int skippedCount = 0;
  bool hasPraised = false;

  final List<Map<String, String>> praiseOptions = [
    {"text": "Good job!", "emoji": "🎉"},
    {"text": "Perfect!", "emoji": "⭐"},
    {"text": "Well done!", "emoji": "👏"},
    {"text": "Great!", "emoji": "🌟"},
    {"text": "Awesome!", "emoji": "💯"},
  ];

  final List<int> skippedIndexes = [];

  String get currentPhrase => widget.phrases[currentIndex];

  Future<void> _speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(currentPhrase);
  }

  Future<void> _listen() async {
    PermissionStatus status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission denied.")),
        );
        return;
      }
    }

    bool available = await speechToText.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
           _evaluateResponse();
          if (childResponse.isNotEmpty && !hasPraised) {
            setState(() {
              praiseText = "Try again";
              praiseEmoji = "👎";
            });
          }
        }
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Speech recognition error: ${error.errorMsg}"),
          ),
        );
      },
    );

    if (available) {
      await speechToText.stop();
      await speechToText.listen(
        onResult: (result) {
          setState(() {
            childResponse = result.recognizedWords;
          });
          _evaluateResponse();
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Speech recognition not available.")),
      );
    }
  }

  Future<void> _playCheerUpSound() async {
    await audioPlayer.play(AssetSource('sounds/cheer-up.mp3'));
  }

  // void _evaluateResponse() {
  //   final input = _sanitizeText(childResponse);
  //   final target = _sanitizeText(currentPhrase);

  //   int inputWordCount = input.split(' ').length;
  //   int targetWordCount = target.split(' ').length;

  //   if (inputWordCount < (targetWordCount * 0.8)) {
  //     return;
  //   }

  //   double matchPercentage = _calculateMatch(input, target);

  //   if (matchPercentage >= 0.9 && !hasPraised) {
  //     final selectedPraise =
  //         praiseOptions[_random.nextInt(praiseOptions.length)];
  //     setState(() {
  //       praiseText = selectedPraise['text']!;
  //       praiseEmoji = selectedPraise['emoji']!;
  //       correctCount++;
  //       hasPraised = true;
  //     });
  //   } else if (matchPercentage < 0.9 &&
  //       childResponse.isNotEmpty &&
  //       !hasPraised) {
  //     setState(() {
  //       praiseText = "Try again";
  //       praiseEmoji = "👎";
  //     });
  //   }
  // }

  void _evaluateResponse() {
  final input = _sanitizeText(childResponse);
  final target = _sanitizeText(currentPhrase);

  double matchPercentage = _calculateMatch(input, target);

  if (matchPercentage >= 0.9 && !hasPraised) {
    final selectedPraise =
        praiseOptions[_random.nextInt(praiseOptions.length)];
    setState(() {
      praiseText = selectedPraise['text']!;
      praiseEmoji = selectedPraise['emoji']!;
      correctCount++;
      hasPraised = true;
    });
  } else if (childResponse.isNotEmpty && !hasPraised) {
    setState(() {
      praiseText = "Try again";
      praiseEmoji = "👎";
    });
  }
}

  String _sanitizeText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r"[^\w\s]"), "").trim();
  }

  double _calculateMatch(String a, String b) {
    List<String> wordsA = a.split(' ');
    List<String> wordsB = b.split(' ');

    int matchCount = 0;
    for (int i = 0; i < wordsA.length; i++) {
      if (i < wordsB.length && wordsA[i] == wordsB[i]) {
        matchCount++;
      }
    }
    return matchCount / wordsB.length;
  }

  void _nextPhrase() {
    speechToText.stop();

    if (childResponse.trim().isEmpty && !hasPraised) {
      skippedCount++;
      if (!skippedIndexes.contains(currentIndex)) {
        skippedIndexes.add(currentIndex);
      }
    }

    setState(() {
      praiseText = "";
      praiseEmoji = "";
      childResponse = "";
      hasPraised = false;

      if (currentIndex < widget.phrases.length - 1) {
        currentIndex++;
      } else {
        if (skippedCount == 0) {
          _markLessonComplete();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Lesson Completed! 🎉"),
              content: const Text(
                "You got all phrases correct! Activity and next Lesson Unlocked",
              ),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () async {
                    await _playCheerUpSound();
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("⚠ Lesson Not Completed"),
              content: Text(
                "You skipped $skippedCount phrase(s).\nPlease correct all phrases to unlock the next lesson.",
              ),
              actions: [
                TextButton(
                  child: const Text("Try Again"),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      currentIndex = skippedIndexes.first;
                      skippedCount = 0;
                      skippedIndexes.clear();
                      praiseText = "";
                      praiseEmoji = "";
                      childResponse = "";
                      hasPraised = false;
                    });
                  },
                ),
              ],
            ),
          );
        }
      }
    });
  }

  void _previousPhrase() {
    speechToText.stop();
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        praiseText = "";
        praiseEmoji = "";
        childResponse = "";
        hasPraised = false;
      }
    });
  }

  // Future<void> _markLessonComplete() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final unlocked = prefs.getInt('unlockedLesson') ?? 0;

  //   if (unlocked <= widget.lessonIndex &&
  //       widget.lessonIndex + 1 < widget.totalLessonCount) {
  //     await prefs.setInt('unlockedLesson', widget.lessonIndex + 1);
  //   }
  // }

  // @override
  // void dispose() {
  //   flutterTts.stop();
  //   speechToText.stop();
  //   super.dispose();
  // }

  Future<void> _markLessonComplete() async {
  final prefs = await SharedPreferences.getInstance();
  final unlocked = prefs.getInt('unlockedLesson') ?? 0;

  if (unlocked <= widget.lessonIndex &&
      widget.lessonIndex + 1 < widget.totalLessonCount) {
    await prefs.setInt('unlockedLesson', widget.lessonIndex + 1);
  }

  // ✅ NEW: notification check added
  bool notificationsOn = await PreferencesHelper.isNotificationEnabled();
  if (notificationsOn) {
    await NotificationService.scheduleActivityReminder(
      lessonIndex: widget.lessonIndex,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / widget.phrases.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 600,
            child: Card(
              color: Colors.deepPurple[50],
              elevation: 10,
              margin: const EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.deepPurple.shade100,
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Phrase ${currentIndex + 1} of ${widget.phrases.length}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentPhrase,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: _speak,
                      icon: const Icon(Icons.volume_up, size: 25),
                      label: const Text(
                        "Play Phrase",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _listen,
                      icon: const Icon(Icons.mic, size: 25),
                      label: const Text(
                        "Say It",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (praiseText.isNotEmpty)
                      Column(
                        children: [
                          Text(praiseEmoji, style: const TextStyle(fontSize: 40)),
                          const SizedBox(height: 5),
                          Text(
                            praiseText,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Text(
                      "You said: \"$childResponse\"",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (currentIndex > 0)
                          SizedBox(
                            width: 140,
                            child: ElevatedButton(
                              onPressed: _previousPhrase,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                              ),
                              child: const Text(
                                "Previous Phrase",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: _nextPhrase,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                          ),
                          child: const Text(
                            "Next Phrase",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
