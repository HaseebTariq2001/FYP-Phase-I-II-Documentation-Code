import 'package:flutter/material.dart';
import 'morning_routine_screen.dart';
import 'going_to_school_screen.dart';
import 'child_dashboard_screen.dart'; // <-- Make sure this path is correct

class RoutineActivitiesScreen extends StatelessWidget {
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
        backgroundColor: const Color(0xFFFDF6FF),
        appBar: AppBar(
          centerTitle: true, // <-- Centers the title

          title: const Text(
            "Cognitive Skills",
            style: TextStyle(color: Colors.white), // <-- Makes the text white
          ),
          backgroundColor: const Color.fromARGB(255, 161, 129, 216),
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
          padding: const EdgeInsets.all(16.0),
          itemCount: routines.length,
          itemBuilder: (context, index) {
            final routine = routines[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.orange,
                    size: 32,
                  ),
                  onPressed: () {
                    if (routine.title == "Learn Your Morning Routine") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MorningRoutineScreen(
                                title: routine.title,
                                imagePath: routine.imagePath,
                                videoPath: routine.videoPath!,
                              ),
                        ),
                      );
                    } else if (routine.title == "Going to School Routine") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => GoingToSchoolScreen(
                                title: routine.title,
                                imagePath: routine.imagePath,
                                videoPath: routine.videoPath!,
                              ),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RoutineItem {
  final String title;
  final String imagePath;
  final String? videoPath;

  RoutineItem({required this.title, required this.imagePath, this.videoPath});
}
