import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MorningRoutineGameScreen extends StatefulWidget {
  final String title;
  final String skill;

  const MorningRoutineGameScreen({
    Key? key,
    required this.title,
    required this.skill,
  }) : super(key: key);

  @override
  _MorningRoutineGameScreenState createState() =>
      _MorningRoutineGameScreenState();
}

class _MorningRoutineGameScreenState extends State<MorningRoutineGameScreen> {
  final List<String> images = [
    'assets/images/wake_up.png',
    'assets/images/brush_teeth.jpeg',
    'assets/images/wash_face.png',
    'assets/images/eat_breakfast.jpeg',
    'assets/images/pack_bag.jpeg',
    'assets/images/go_to_school.jpeg',
  ];

  List<String?> userArrangement = [null, null, null, null, null, null];
  late List<String> shuffledImages;

  bool gameComplete = false;
  int correctCount = 0;

  @override
  void initState() {
    super.initState();
    shuffledImages = List.from(images)..shuffle();
  }

  void _restartGame() {
    setState(() {
      userArrangement = [null, null, null, null, null, null];
      shuffledImages = List.from(images)..shuffle();
      gameComplete = false;
      correctCount = 0;
    });
  }

  void _clearBox(int index) {
    setState(() {
      if (userArrangement[index] != null) {
        shuffledImages.add(userArrangement[index]!);
        userArrangement[index] = null;
      }
    });
  }

  void _showResultDialog(String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getInt('child_id');

    await http.post(
      Uri.parse('https://educare-backend-9nb1.onrender.com/api/save-activity'),
      // Uri.parse('http://100.64.64.88:8000/api/save-activity'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'child_id': childId,
        'activity_name': 'Morning Routine Game',
        'skill_category': 'Cognitive',
        'correct_phrases': correctCount,
        'total_phrases': images.length,
      }),
    );
  }

  void _handleSubmit() async {
    if (userArrangement.contains(null)) {
      _showResultDialog(
        'Incomplete',
        'Please complete all steps before submitting.',
      );
      return;
    }

    int correct = 0;
    for (int i = 0; i < 6; i++) {
      if (userArrangement[i] == images[i]) {
        correct++;
      }
    }

    setState(() {
      correctCount = correct;
      gameComplete = true;
    });

    if (correctCount == 6) {
      _showResultDialog(
        'Congratulations!',
        'Well done! You completed the sequence correctly!',
      );
    } else {
      _showResultDialog(
        'Good Try!',
        'You got $correctCount out of 6 steps right. Keep trying!',
      );
    }

    // ✅ Save progress to backend
    await _saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morning Routine Game'),
        backgroundColor: const Color.fromARGB(255, 161, 129, 216),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Please arrange the pictures in the correct order',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Draggable images
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children:
                    shuffledImages.map((imgPath) {
                      return Draggable<String>(
                        data: imgPath,
                        childWhenDragging: Container(),
                        feedback: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(imgPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(imgPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),

              // Drop targets
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return GestureDetector(
                        onDoubleTap: () => _clearBox(index),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child:
                              userArrangement[index] != null
                                  ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(userArrangement[index]!),
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                        ),
                      );
                    },
                    onWillAccept: (image) => true,
                    onAccept: (image) {
                      setState(() {
                        if (userArrangement[index] != null) {
                          shuffledImages.add(userArrangement[index]!);
                        }

                        int existingIndex = userArrangement.indexWhere(
                          (e) => e == image,
                        );
                        if (existingIndex != -1) {
                          userArrangement[existingIndex] = null;
                        }

                        userArrangement[index] = image;
                        shuffledImages.remove(image);
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              if (!gameComplete)
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 161, 129, 216),
                  ),
                ),

              if (gameComplete)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _restartGame,
                      child: const Text('Play Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          161,
                          129,
                          216,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
