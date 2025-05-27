import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EmotionSortingScreen extends StatefulWidget {
  final String title; // Added to receive activity title
  final String skill; // Added to receive skill category

  const EmotionSortingScreen({
    Key? key,
    required this.title,
    required this.skill,
  }) : super(key: key);

  @override
  State<EmotionSortingScreen> createState() => _EmotionSortingScreenState();
}

class _EmotionSortingScreenState extends State<EmotionSortingScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts tts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();

  final Map<String, String> emotions = {
    'joy': 'good',
    'excitement': 'good',
    'love': 'good',
    'anger': 'bad',
    'fear': 'bad',
    'scared': 'bad',
  };

  final List<String> goodFeelings = [];
  final List<String> badFeelings = [];
  // Added to store responses for result dialog
  List<Map<String, dynamic>> responses = [];

  bool questionSpoken = false;
  List<String> remainingEmotions = [];
  String? currentEmotion;
  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    remainingEmotions = emotions.keys.toList()..shuffle();
    _setNextEmotion();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );

    _speakQuestion();
  }

  void _setNextEmotion() {
    if (remainingEmotions.isNotEmpty) {
      setState(() {
        currentEmotion = remainingEmotions.removeAt(0);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationController?.forward(from: 0);
      });
    } else {
      currentEmotion = null;
      _playSound('cheer-up.mp3');
      _saveProgress(); // Save score to database
      _showResultDialog(); // Show results
    }
  }

  Future<void> _speakQuestion() async {
    await Future.delayed(Duration(milliseconds: 500));
    await tts.setLanguage('en-US');
    await tts.setSpeechRate(0.5);
    await tts.speak(
      'Can you sort the emotions into Good Feelings and Bad Feelings?',
    );
    setState(() => questionSpoken = true);
  }

  void _playSound(String fileName) {
    audioPlayer.play(AssetSource('sounds/$fileName'));
  }

  void _handleDrop(String emotionKey, String targetBox) {
    final correctBox = emotions[emotionKey];
    final isCorrect = correctBox == targetBox;

    _playSound(isCorrect ? 'positive-answer.mp3' : 'wrong-answer.mp3');

    setState(() {
      if (targetBox == 'good') {
        goodFeelings.add(emotionKey);
      } else {
        badFeelings.add(emotionKey);
      }
      // Store response for result dialog
      responses.add({
        'emotion': emotionKey,
        'sorted': targetBox,
        'status': isCorrect ? 'Correct' : 'Incorrect',
      });
    });

    Future.delayed(Duration(milliseconds: 500), _setNextEmotion);
  }

  // Added to save score to database
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getInt('child_id');

    final correct = responses.where((r) => r['status'] == 'Correct').length;
    final total = emotions.length;

    await http.post(
      Uri.parse('http://192.168.1.10:8000/api/save-activity'),
      // Uri.parse('http://100.64.64.88:8000/api/save-activity'),
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
    final total = emotions.length;

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
                              title: Text("Emotion: ${entry['emotion']}"),
                              subtitle: Text("Sorted as: ${entry['sorted']}"),
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

  Widget _buildDraggable(String emotionKey) {
    return SlideTransition(
      position: _slideAnimation!,
      child: Draggable<String>(
        data: emotionKey,
        feedback: Material(
          color: Colors.transparent,
          child: _buildDraggableImage(emotionKey, size: 150),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _buildDraggableImage(emotionKey, size: 140),
        ),
        child: _buildDraggableImage(emotionKey, size: 140),
      ),
    );
  }

  Widget _buildDraggableImage(String emotionKey, {required double size}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent, width: 3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/$emotionKey-fruit.jpeg',
          height: size,
          width: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDropTarget(
    String label,
    String targetBox,
    List<String> currentList,
  ) {
    return DragTarget<String>(
      onAccept: (data) => _handleDrop(data, targetBox),
      builder:
          (context, candidateData, rejectedData) => Container(
            width: 150,
            height: 260,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  targetBox == 'good'
                      ? Colors.lightGreen[100]
                      : Colors.red[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ...currentList.map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: BounceWidget(
                      key: ValueKey(e),
                      child: Image.asset(
                        'assets/images/$e-fruit.jpeg',
                        height: 50,
                        width: 50,
                      ),
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
    tts.stop();
    audioPlayer.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(widget.title)), // Use passed title
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        iconTheme: const IconThemeData(color: Colors.black), // added for icon
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/question-ask.png', height: 60),
                  SizedBox(width: 12),
                  Expanded(
                    child:
                        questionSpoken
                            ? DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Can you sort the emotions into Good Feelings and Bad Feelings?',
                                    speed: Duration(milliseconds: 30),
                                  ),
                                ],
                                isRepeatingAnimation: false,
                              ),
                            )
                            : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            if (currentEmotion != null)
              Center(child: _buildDraggable(currentEmotion!)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDropTarget("Good Feelings", "good", goodFeelings),
                _buildDropTarget("Bad Feelings", "bad", badFeelings),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BounceWidget extends StatefulWidget {
  final Widget child;
  final Key key;

  BounceWidget({required this.child, required this.key}) : super(key: key);

  @override
  _BounceWidgetState createState() => _BounceWidgetState();
}

class _BounceWidgetState extends State<BounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
