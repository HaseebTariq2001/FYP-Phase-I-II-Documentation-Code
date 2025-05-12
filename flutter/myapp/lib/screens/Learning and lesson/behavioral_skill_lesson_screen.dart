// // ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'child_dashboard_screen.dart';

class BehavioralSkillsScreen extends StatefulWidget {
  @override
  _BehavioralSkillsScreenState createState() => _BehavioralSkillsScreenState();
}

class _BehavioralSkillsScreenState extends State<BehavioralSkillsScreen> {
  List<Map<String, dynamic>> lessons = [
    {
      'title': 'Understanding Emotions',
      'subtitle': 'Lesson 1',
      'image': 'assets/images/multiple-emotions-kids.jpeg',
      'route': '/lessonDetail',
    },
    {
      'title': 'Recognizing Behavior',
      'subtitle': 'Lesson 2',
      'image': 'assets/images/Recognizing-Behavior.jpeg',
      'route': '/lessonDetail',
    },
    {
      'title': 'Social Cues and Body Language',
      'subtitle': 'Lesson 3',
      'image': 'assets/images/Social-Cues.jpeg',
      'route': '/lessonDetail',
    },
  ];

  int unlockedLesson = 0;

  @override
  void initState() {
    super.initState();
    _loadUnlockedLesson();
  }

  /// Loads the highest unlocked lesson index from shared preferences
  Future<void> _loadUnlockedLesson() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unlockedLesson = prefs.getInt('unlockedLesson') ?? 0;
    });
  }

  /// Saves the next unlocked lesson index if current lesson is completed
  Future<void> _checkAndUnlockNextLesson(int currentIndex) async {
    final prefs = await SharedPreferences.getInstance();

    // Simulate score checking (replace with actual logic if needed)
    final completed =
        prefs.getBool('lesson_${currentIndex}_completed') ?? false;

    if (completed &&
        currentIndex == unlockedLesson &&
        currentIndex + 1 < lessons.length) {
      await prefs.setInt('unlockedLesson', currentIndex + 1);
      setState(() {
        unlockedLesson = currentIndex + 1;
      });
    }
  }

  /// Marks current lesson as completed (you can call this from lesson screen)
  Future<void> markLessonAsCompleted(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lesson_${index}_completed', true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LearningTabScreen()),
        );
        return false;
      },
      child: Scaffold(
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
          padding: const EdgeInsets.all(16),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            final isLocked = index > unlockedLesson;

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isLocked ? Colors.grey[200] : Colors.deepPurpleAccent,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    lesson['image'],
                    width: 70,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  lesson['subtitle'],
                  style: TextStyle(
                    color: isLocked ? Colors.black54 : Colors.white,
                  ),
                ),
                subtitle: Text(
                  lesson['title'],
                  style: TextStyle(
                    color: isLocked ? Colors.black45 : Colors.white70,
                  ),
                ),
                trailing: Icon(
                  isLocked ? Icons.lock_outline : Icons.play_arrow,
                  color: isLocked ? Colors.grey : Colors.white,
                ),
                onTap: () async {
                  if (isLocked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please complete the previous lesson first.",
                        ),
                      ),
                    );
                  } else {
                    final result = await Navigator.pushNamed(
                      context,
                      lesson['route'],
                      arguments: {
                        'title': lesson['title'],
                        'lessonIndex': index,
                      },
                    );

                    // If the lesson was marked complete, update progress
                    if (result == 'completed') {
                      await markLessonAsCompleted(index);
                      await _checkAndUnlockNextLesson(index);
                    }
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
