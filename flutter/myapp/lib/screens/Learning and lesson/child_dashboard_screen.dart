import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/screens/Learning and lesson/course_detail_screen.dart';
import 'package:myapp/screens/Learning and lesson/behavioral_skill_lesson_screen.dart';
import 'package:myapp/screens/Learning and lesson/routine_submodule_screen.dart';
import 'package:myapp/screens/activity_screens/activity_detail_screen.dart';
import 'package:myapp/screens/activity_screens/behavior_activity_list.dart';

import '../progress_report_screen.dart' show ProgressReportScreen;

class LearningTabScreen extends StatelessWidget {
  Future<Map<String, dynamic>> fetchChildData(String name) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.6:8000/child/$name'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load child data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
          ),
          title: Text(
            "Child Dashboard",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            tabs: [Tab(text: "Learning Modules"), Tab(text: "Games")],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // DrawerHeader(
              //   decoration: BoxDecoration(color: Colors.blue),
              //   child: Column(
              //     children: [
              //       Image.asset(
              //         'assets/images/logo_pic.png',
              //         height: 100,
              //         width: 100,
              //         fit: BoxFit.contain,
              //       ),

              //       const SizedBox(width: 8),

              //       Text(
              //         'EDUCARE',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 24,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: fetchChildData(
                    "waheed",
                  ), // Replace with actual name variable
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: Colors.white);
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error loading profile',
                        style: TextStyle(color: Colors.white),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text(
                        'No profile found',
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    final childData = snapshot.data!;
                    final imageBytes = base64Decode(
                      childData['image_blob'] ?? "",
                    );

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(imageBytes),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          childData['name'] ?? "Child Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              ListTile(
                leading: Icon(Icons.stacked_bar_chart_sharp),
                title: Text('Progress report'),
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgressReportScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  final GoogleSignIn _googleSignIn = GoogleSignIn();
                  await FirebaseAuth.instance.signOut();
                  await _googleSignIn.signOut();

                  Navigator.pop(context); // Close dialog
                  Navigator.pushReplacementNamed(
                    context,
                    "/login",
                  ); // Navigate to Login Screen
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Learning Modules
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCard(
                    imagePath: 'assets/images/repeat_after_me.jpg',
                    title: "Communication Skills",
                    subtitle: "Part 1 • Level 1 - Level 5",
                    buttonText: "Start Learning",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => CourseDetailScreen()),
                      );
                    },
                  ),
                  _buildCard(
                    imagePath: 'assets/images/Behavioral skill.jpeg',
                    title: "Behavioral Skills",
                    subtitle: "Part 2 • Level 1 - Level 3",
                    buttonText: "Start Learning",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BehavioralSkillsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    imagePath: 'assets/images/cognitive_skills.png',
                    title: "Cognitive Skills",
                    subtitle: " Part 3 • Level 1 - Level 2",
                    buttonText: "Start Learning",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoutineActivitiesScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Tab 2: Games and Activities
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCard(
                    imagePath: 'assets/images/repeat_after_me.jpg',
                    title: "Communication Skills (Games and Activities)",
                    subtitle: "Part 2 • Level 1 - Level 5",
                    buttonText: "Play Games",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActivityDetailScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    imagePath: 'assets/images/understanding-emotion.jpeg',
                    title: "Behavioral Skills (Games and Activities)",
                    subtitle: "Level 1 - Level 3",
                    buttonText: "Play Games",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BehavioralSkillsActivityScreen(),
                        ),
                      );
                    },
                  ),

                  _buildCard(
                    imagePath: 'assets/images/cognitive_skills.png',
                    title: "Cognitive Skills (Games and Activities)",
                    subtitle: "Level 1 - Level 2",
                    buttonText: "Play Games",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  RoutineActivitiesScreen(), //add your activity list route
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              imagePath,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 183, 58, 177),
                  foregroundColor: Colors.white,
                  shape: StadiumBorder(),
                ),
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
