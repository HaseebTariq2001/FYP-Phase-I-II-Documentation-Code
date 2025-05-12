// // ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:myapp/screens/Learning%20and%20lesson/child_dashboard_screen.dart';
import 'package:myapp/screens/activity_screens/emotion_sorting_screen.dart'
    show EmotionSortingScreen;
import 'package:myapp/screens/activity_screens/tap_good_activity.dart'
    show TapGoodBehaviorActivityScreen;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/screens/activity_screens/match_emotion_activity_screen.dart'; // Import activity screen
import 'package:myapp/screens/activity_screens/emotion_sorting_screen.dart'; // Import activity screen
import 'package:myapp/screens/activity_screens/tap_good_activity.dart'; // Import activity screen

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
      'skill': 'Behavioral',
      'image': 'assets/images/multiple-emotions-kids.jpeg',
      'screen':
          (String title, String skill) =>
              MatchEmotionActivityScreen(title: title, skill: skill),
      'locked': true,
    },
    {
      'title': 'Emotion Sorting',
      'subtitle': 'Activity 2',
      'skill': 'Behavioral',
      'image': 'assets/images/Recognizing-Behavior.jpeg',
      'screen':
          (String title, String skill) =>
              EmotionSortingScreen(title: title, skill: skill),
      'locked': true,
    },
    {
      'title': 'Tap Good Behavior',
      'subtitle': 'Activity 3',
      'skill': 'Behavioral',
      'image': 'assets/images/saying-thanks.jpeg',
      'screen':
          (String title, String skill) =>
              TapGoodBehaviorActivityScreen(title: title, skill: skill),
      'locked': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLessonStates();
  }

  // Load activity unlock states based on corresponding lesson completion
  Future<void> _loadLessonStates() async {
    final prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < lessons.length; i++) {
      final lessonCompleted = prefs.getBool('lesson_${i}_completed') ?? false;
      lessons[i]['locked'] = !lessonCompleted;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          "Behavioral Skills",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                // Check if screen function exists to prevent null call
                if (lesson['screen'] != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => lesson['screen'](
                            lesson['title'],
                            lesson['skill'],
                          ),
                    ),
                  );

                  // Handle completion signal
                  if (result == 'completed') {
                    _loadLessonStates(); // Refresh the list
                  }
                } else {
                  // Log error for debugging
                  print(
                    'Error: screen function is null for ${lesson['title']}',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Activity not available: ${lesson['title']}',
                      ),
                    ),
                  );
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
