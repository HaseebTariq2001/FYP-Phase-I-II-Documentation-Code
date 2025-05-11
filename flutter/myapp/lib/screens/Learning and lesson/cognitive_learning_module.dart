import 'package:flutter/material.dart';
import 'routine_submodule_screen.dart'; // Make sure this file exists in your project

class CognitiveLearningModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF6FF), // Light purple/pinkish background
      appBar: AppBar(
        title: Text("Learning Modules"),
        backgroundColor: const Color.fromARGB(255, 161, 129, 216),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ModuleCard(
          title: 'Cognitive Skills',
          imagePath: 'assets/images/cognitive_skills.png', // Replace with your actual image
          part: 'Part 1',
          levelRange: 'Level 1 - Level 3',
          onJoin: () {
            // Navigate to routine activities screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RoutineActivitiesScreen()),
            );
          },
        ),
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String part;
  final String levelRange;
  final VoidCallback onJoin;

  const ModuleCard({
    required this.title,
    required this.imagePath,
    required this.part,
    required this.levelRange,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              imagePath,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Texts and button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '$part - $levelRange',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onJoin,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color.fromARGB(255, 161, 129, 216),
                    ),
                    child: Text("Join"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
