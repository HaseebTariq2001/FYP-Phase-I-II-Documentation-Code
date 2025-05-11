// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:myapp/screens/Learning%20and%20lesson/child_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BehavioralSkillsActivityScreen extends StatefulWidget {
  @override
  _BehavioralSkillsScreenState createState() => _BehavioralSkillsScreenState();
}

class _BehavioralSkillsScreenState
    extends State<BehavioralSkillsActivityScreen> {
  List<Map<String, dynamic>> lessons = [
    {
      'title': 'Understanding Emotions',
      'subtitle': 'Activity 1',
      'image': 'assets/images/multiple-emotions-kids.jpeg',
      'route': '/BehavioralActivities',
      'locked': false, // First lesson is always unlocked
    },
    {
      'title': 'Emotion Sorting',
      'subtitle': 'Activity 2',
      'image': 'assets/images/Recognizing-Behavior.jpeg',
      'route': '/emotionsortingActivity',
      'locked': true,
    },
    {
      'title': 'Tap Good Behavior',
      'subtitle': 'Activity 3',
      'image': 'assets/images/saying-thanks.jpeg',
      'route': '/tapgoodactivity',
      'locked': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLessonStates();
  }

  // Load lesson states from SharedPreferences
  Future<void> _loadLessonStates() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < lessons.length; i++) {
      // Skip the first lesson as it's always unlocked
      if (i > 0) {
        final isUnlocked = prefs.getBool('lesson_$i') ?? false;
        setState(() {
          lessons[i]['locked'] = !isUnlocked;
        });
      }
    }
  }

  // Save lesson state to SharedPreferences when unlocked
  Future<void> _saveLessonState(int lessonIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lesson_$lessonIndex', true);
  }

  void unlockNextLesson(int currentIndex) {
    if (currentIndex + 1 < lessons.length &&
        lessons[currentIndex + 1]['locked']) {
      setState(() {
        lessons[currentIndex + 1]['locked'] = false;
      });
      // Save the unlocked state
      _saveLessonState(currentIndex + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Purple background
        centerTitle: true, // Center the title
        title: const Text(
          "Behavioral Skills",
          style: TextStyle(color: Colors.white), // White text
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // White back icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LearningTabScreen()),
            );
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final isLocked = lesson['locked'];

          return GestureDetector(
            onTap: () async {
              if (!isLocked) {
                // Wait for result from the lesson screen
                final result = await Navigator.pushNamed(
                  context,
                  lesson['route'],
                  arguments: {
                    'title': lesson['title'],
                    'onComplete': () => unlockNextLesson(index),
                  },
                );

                // Check if user completed the lesson
                if (result == 'completed') {
                  unlockNextLesson(index);
                }
              }
            },
            child: Opacity(
              opacity: isLocked ? 0.5 : 1,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: !isLocked ? Colors.purple[50] : Colors.grey[200],
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          lesson['image'],
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson['subtitle'],
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              lesson['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isLocked ? Icons.lock : Icons.play_arrow,
                        color: isLocked ? Colors.grey : Colors.deepPurple,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
