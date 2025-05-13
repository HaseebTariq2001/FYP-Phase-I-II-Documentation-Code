import 'package:flutter/material.dart';
import 'package:myapp/screens/Learning%20and%20lesson/child_dashboard_screen.dart';
import 'package:myapp/screens/activity_screens/going_to_school_game.dart';
import 'package:myapp/screens/activity_screens/morning_routine_game.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CognitiveActivityDetailScreen extends StatefulWidget {
  @override
  _CognitiveActivityDetailScreenState createState() =>
      _CognitiveActivityDetailScreenState();
}

class _CognitiveActivityDetailScreenState
    extends State<CognitiveActivityDetailScreen> {
  final List<Map<String, dynamic>> activities = [
    {
      'title': "Morning Routine Game",
      'skill': "Cognitive",
      'image': 'assets/images/morning_routine.png',
      'screen': (String title, String skill) =>
          MorningRoutineGameScreen(title: title, skill: skill),
    },
    {
      'title': "Going to School Routine",
      'skill': "Cognitive",
      'image': 'assets/images/going_to_school.png',
      'screen': (String title, String skill) =>
          GoingToSchoolRoutineGameScreen(title: title, skill: skill),
    },
  ];

  int unlockedRoutine = 0;

  @override
  void initState() {
    super.initState();
    _loadRoutineProgress();
  }

  Future<void> _loadRoutineProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unlockedRoutine = prefs.getInt('unlockedRoutine') ?? 0;
    });
  }

  void _handleActivityTap(int index) async {
    if (index >= unlockedRoutine) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete the corresponding routine first.")),
      );
    } else {
      if (activities[index]['screen'] != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => activities[index]['screen'](
              activities[index]['title'],
              activities[index]['skill'],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cognitive Activities"),
        backgroundColor: const Color.fromARGB(255, 161, 129, 216),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          final isLocked = index >= unlockedRoutine;

          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            color: isLocked
                ? Colors.grey[200]
                : const Color.fromARGB(255, 183, 58, 177),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  activity['image'],
                  width: 70,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Activity ${index + 1}",
                style: TextStyle(
                    color: isLocked ? Colors.black54 : Colors.white),
              ),
              subtitle: Text(
                activity['title'],
                style: TextStyle(
                    color: isLocked ? Colors.black45 : Colors.white70),
              ),
              trailing: Icon(
                isLocked ? Icons.lock_outline : Icons.play_arrow,
                color: isLocked ? Colors.grey : Colors.white,
              ),
              onTap: () => _handleActivityTap(index),
            ),
          );
        },
      ),
    );
  }
}
