// new additions

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';

class EmotionSortingScreen extends StatefulWidget {
  const EmotionSortingScreen({Key? key}) : super(key: key);

  @override
  State<EmotionSortingScreen> createState() => _EmotionSortingScreenState();
}

// Only relevant changes shown below with comments

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

  bool showNextButton = false;
  bool questionSpoken = false;

  List<String> remainingEmotions = [];
  String? currentEmotion;
  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    // ✅ Shuffle the emotion keys for random order
    remainingEmotions = emotions.keys.toList()..shuffle();
    _setNextEmotion();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    // ✅ Slide in from left to center (Offset(0,0))
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

      // Start animation after widget has been built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationController?.forward(from: 0);
      });
    } else {
      currentEmotion = null;
      if (_isAllCorrect()) {
        _playSound('cheer-up.mp3');
        _showCongratsDialog();
      }
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

    if (correctBox == targetBox) {
      _playSound('positive-answer.mp3');

      setState(() {
        if (targetBox == 'good') {
          goodFeelings.add(emotionKey);
        } else {
          badFeelings.add(emotionKey);
        }
      });

      Future.delayed(Duration(milliseconds: 500), _setNextEmotion);
    } else {
      _playSound('wrong-answer.mp3');
    }
  }

  bool _isAllCorrect() {
    for (var item in goodFeelings) {
      if (emotions[item] != 'good') return false;
    }
    for (var item in badFeelings) {
      if (emotions[item] != 'bad') return false;
    }
    return true;
  }

  void _showCongratsDialog() {
    setState(() => showNextButton = true);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("🎉 Great Job!"),
            content: Text("You sorted all emotions correctly!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Continue"),
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

  // ✅ New helper to build bordered draggable image
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
            width: 150, // ✅ Increased box width
            height: 260, // ✅ Increased box height
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
                // ✅ Larger dropped image size
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
    _animationController?.dispose(); // ✅ dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emotion Sorting")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // ✅ Question cloud container
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

            // ✅ Show only one draggable image at a time
            if (currentEmotion != null)
              Center(child: _buildDraggable(currentEmotion!)),

            SizedBox(height: 20),

            // Drop targets
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDropTarget("Good Feelings", "good", goodFeelings),
                _buildDropTarget("Bad Feelings", "bad", badFeelings),
              ],
            ),

            SizedBox(height: 20),

            // Next button
            if (showNextButton)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(); // Update this to push for next screen
                },
                child: Text("Next"),
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
