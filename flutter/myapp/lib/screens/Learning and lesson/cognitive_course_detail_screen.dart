import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'child_dashboard_screen.dart';
import 'morning_routine_screen.dart';
import 'going_to_school_screen.dart';

class CognitiveCourseDetailScreen extends StatefulWidget {
  @override
  _CognitiveCourseDetailScreenState createState() =>
      _CognitiveCourseDetailScreenState();
}

class _CognitiveCourseDetailScreenState
    extends State<CognitiveCourseDetailScreen> {
  final List<RoutineItem> routines = [
    RoutineItem(
      title: "Learn Your Morning Routine",
      imagePath: "assets/images/morning_routine.png",
      videoPath: 'assets/videos/morning_routine.mp4',
    ),
    RoutineItem(
      title: "Going to School Routine",
      imagePath: "assets/images/going_to_school.png",
      videoPath: 'assets/videos/going_to_school_routine.mp4',
    ),
  ];

  int unlockedRoutine = 0; // Initially, only "Learn Your Morning Routine" is unlocked

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // Load the unlocked routine from shared preferences
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unlockedRoutine = prefs.getInt('unlockedRoutine') ?? 0; // Default to 0 if not set
    });
  }

  // Handle the tapping of a routine, including checking if it's unlocked
  void _handleRoutineTap(int index) {
    if (index > unlockedRoutine) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete the previous routine first.")),
      );
    } else {
      // Handle the navigation to the next routine screen
      if (routines[index].title == "Learn Your Morning Routine") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MorningRoutineScreen(
              title: routines[index].title,
              imagePath: routines[index].imagePath,
              videoPath: routines[index].videoPath!,
            ),
          ),
        ).then((_) => _checkAndUnlockRoutine(index)); // After video completion, unlock next
      } else if (routines[index].title == "Going to School Routine") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoingToSchoolScreen(
              title: routines[index].title,
              imagePath: routines[index].imagePath,
              videoPath: routines[index].videoPath!,
            ),
          ),
        ).then((_) => _checkAndUnlockRoutine(index)); // After video completion, unlock next
      }
    }
  }

  // Check if the user has completed the current routine and unlock the next one
  // Future<void> _checkAndUnlockRoutine(int index) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   if (index == unlockedRoutine) {
  //     // Unlock the next routine after completing the current one
  //     if (index == 0) {
  //       // Unlock "Going to School Routine" and Game 1 ("Morning Routine Game")
  //       await prefs.setInt('unlockedRoutine', 1);  // Unlock the "Going to School Routine"
  //       await prefs.setInt('unlockedActivity', 1);  // Unlock game 1 (Morning Routine Game)
  //     } else if (index == 1) {
  //       // Unlock Game 2 ("Going to School Routine Game") after completing lesson 2
  //       await prefs.setInt('unlockedActivity', 2);  // Unlock game 2 (Going to School Routine Game)
  //     }
  //     setState(() {
  //       unlockedRoutine = index + 1;
  //     });
  //   }
  // }
  
  Future<void> _checkAndUnlockRoutine(int index) async {
  final prefs = await SharedPreferences.getInstance();

  if (index == unlockedRoutine) {
    // ✅ Only unlock the next routine after completing current routine
    await prefs.setInt('unlockedRoutine', unlockedRoutine + 1);

    setState(() {
      unlockedRoutine = unlockedRoutine + 1;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FF),
      appBar: AppBar(
        title: const Text("Cognitive Skills"),
        backgroundColor: const Color.fromARGB(255, 161, 129, 216),
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
        padding: const EdgeInsets.all(16.0),
        itemCount: routines.length,
        itemBuilder: (context, index) {
          final routine = routines[index];
          final isLocked = index > unlockedRoutine;

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isLocked ? Colors.grey[200] : const Color.fromARGB(255, 183, 58, 177),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  routine.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                routine.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.black54 : Colors.white),
              ),
              trailing: Icon(
                isLocked ? Icons.lock_outline : Icons.play_arrow,
                color: isLocked ? Colors.grey : Colors.white,
              ),
              onTap: () => _handleRoutineTap(index),
            ),
          );
        },
      ),
    );
  }
}

class RoutineItem {
  final String title;
  final String imagePath;
  final String? videoPath;

  RoutineItem({
    required this.title,
    required this.imagePath,
    this.videoPath,
  });
}
