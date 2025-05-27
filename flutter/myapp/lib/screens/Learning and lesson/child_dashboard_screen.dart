// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'package:myapp/screens/Learning and lesson/course_detail_screen.dart';
// import 'package:myapp/screens/Learning and lesson/behavioral_skill_lesson_screen.dart';
// import 'package:myapp/screens/activity_screens/activity_detail_screen.dart';
// import 'package:myapp/screens/activity_screens/behavior_activity_list.dart';
// import 'package:myapp/screens/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:myapp/screens/activity_screens/cognitive_activity_detail_screen.dart';
// import 'package:myapp/screens/Learning and lesson/cognitive_course_detail_screen.dart';
// import 'package:audioplayers/audioplayers.dart';

// import '../progress_report_screen.dart' show ProgressReportScreen;

// class LearningTabScreen extends StatelessWidget {
//   Future<Map<String, dynamic>> fetchChildData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final childName = prefs.getString('child_name');

//     if (childName == null) {
//       throw Exception("Child name not found in local storage.");
//     }

//     final response = await http.get(
//       // Uri.parse('http://192.168.1.10:8000/child/$childName'),
//       Uri.parse('http://100.64.64.88:8000/child/$childName'),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load child data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: Builder(
//             builder:
//                 (context) => IconButton(
//                   icon: Icon(Icons.menu, color: Colors.white),
//                   onPressed: () {
//                     Scaffold.of(context).openDrawer();
//                   },
//                 ),
//           ),
//           title: Text(
//             "Child Dashboard",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Colors.blue,
//           centerTitle: true,
//           bottom: TabBar(
//             indicatorColor: Colors.white,
//             labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.white.withOpacity(0.6),
//             tabs: [Tab(text: "Learning Modules"), Tab(text: "Games")],
//           ),
//         ),
//         drawer: _DrawerWidget(fetchChildData: fetchChildData),
//         body: TabBarView(
//           children: [
//             // Tab 1: Learning Modules
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildCard(
//                     imagePath: 'assets/images/repeat_after_me.jpg',
//                     title: "Communication Skills",
//                     subtitle: "Part 1 • Level 1 - Level 5",
//                     buttonText: "Start Learning",
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (_) => CourseDetailScreen()),
//                       );
//                     },
//                   ),
//                   _buildCard(
//                     imagePath: 'assets/images/Behavioral skill.jpeg',
//                     title: "Behavioral Skills",
//                     subtitle: "Part 2 • Level 1 - Level 3",
//                     buttonText: "Start Learning",
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => BehavioralSkillsScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildCard(
//                     imagePath: 'assets/images/cognitive_skills.png',
//                     title: "Cognitive Skills",
//                     subtitle: " Part 3 • Level 1 - Level 2",
//                     buttonText: "Start Learning",
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => CognitiveCourseDetailScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             // Tab 2: Games and Activities
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildCard(
//                     imagePath: 'assets/images/repeat_after_me.jpg',
//                     title: "Communication Skills (Games and Activities)",
//                     subtitle: "Part 2 • Level 1 - Level 5",
//                     buttonText: "Play Games",
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ActivityDetailScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildCard(
//                     imagePath: 'assets/images/understanding-emotion.jpeg',
//                     title: "Behavioral Skills (Games and Activities)",
//                     subtitle: "Level 1 - Level 3",
//                     buttonText: "Play Games",
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => BehavioralSkillsActivityScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildCard(
//                     imagePath: 'assets/images/cognitive_skills.png',
//                     title: "Cognitive Skills (Games and Activities)",
//                     subtitle: "Level 1 - Level 2",
//                     buttonText: "Play Games",
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => CognitiveActivityDetailScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCard({
//     required String imagePath,
//     required String title,
//     required String subtitle,
//     required String buttonText,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             child: Image.asset(
//               imagePath,
//               height: 220,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Padding(
//               padding: const EdgeInsets.only(right: 16.0, bottom: 12),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 183, 58, 177),
//                   foregroundColor: Colors.white,
//                   shape: StadiumBorder(),
//                 ),
//                 onPressed: onPressed,
//                 child: Text(buttonText),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DrawerWidget extends StatefulWidget {
//   final Future<Map<String, dynamic>> Function() fetchChildData;

//   const _DrawerWidget({required this.fetchChildData});

//   @override
//   _DrawerWidgetState createState() => _DrawerWidgetState();
// }

// class _DrawerWidgetState extends State<_DrawerWidget> {
//   late Future<Map<String, dynamic>> _childDataFuture;
//   String? _childNameKey;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFuture();
//   }

//   // Initialize the Future and child name key for the FutureBuilder
//   void _initializeFuture() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _childNameKey = prefs.getString('child_name') ?? 'default';
//       _childDataFuture = widget.fetchChildData();
//     });
//   }

//   // Refresh the Future to fetch new data when the drawer is opened
//   void _refreshChildData() {
//     setState(() {
//       _childDataFuture = widget.fetchChildData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Call _refreshChildData when the drawer is opened
//     _refreshChildData();

//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: FutureBuilder<Map<String, dynamic>>(
//               key: ValueKey(_childNameKey), // Rebuild when child name changes
//               future: _childDataFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator(color: Colors.white);
//                 } else if (snapshot.hasError) {
//                   return Text(
//                     'Error loading profile',
//                     style: TextStyle(color: Colors.white),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data == null) {
//                   return Text(
//                     'No profile found',
//                     style: TextStyle(color: Colors.white),
//                   );
//                 }

//                 final childData = snapshot.data!;
//                 final imageBlob = childData['image_blob'];
//                 final imageBytes =
//                     (imageBlob != null && imageBlob.isNotEmpty)
//                         ? base64Decode(imageBlob)
//                         : null;

//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Colors.white,
//                       child:
//                           imageBytes != null
//                               ? ClipOval(
//                                 child: Image.memory(
//                                   imageBytes,
//                                   fit: BoxFit.cover,
//                                   width: 80,
//                                   height: 80,
//                                   errorBuilder:
//                                       (context, error, stackTrace) => Icon(
//                                         Icons.person,
//                                         size: 40,
//                                         color: Colors.grey,
//                                       ),
//                                 ),
//                               )
//                               : Icon(
//                                 Icons.person,
//                                 size: 40,
//                                 color: Colors.grey,
//                               ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       childData['name'] ?? "Child Name",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.stacked_bar_chart_sharp),
//             title: Text('Progress report'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProgressReportScreen()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.switch_account),
//             title: Text('Switch Dashboard'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomeScreen()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text(
//               'Logout',
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//             onTap: () async {
//               // Initialize Google Sign-In and Firebase Auth
//               final GoogleSignIn _googleSignIn = GoogleSignIn();
//               await FirebaseAuth.instance.signOut();
//               await _googleSignIn.signOut();

//               // Clear child_name from SharedPreferences to prevent stale data
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.remove('child_name');

//               // Close the drawer and navigate to the login screen
//               Navigator.pop(context); // Close drawer
//               Navigator.pushReplacementNamed(
//                 context,
//                 "/login",
//               ); // Navigate to Login Screen
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/screens/child_dashboard_screen.dart

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/screens/Learning and lesson/course_detail_screen.dart';
import 'package:myapp/screens/Learning and lesson/behavioral_skill_lesson_screen.dart';
import 'package:myapp/screens/activity_screens/activity_detail_screen.dart';
import 'package:myapp/screens/activity_screens/behavior_activity_list.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/activity_screens/cognitive_activity_detail_screen.dart';
import 'package:myapp/screens/Learning and lesson/cognitive_course_detail_screen.dart';
import 'package:myapp/screens/progress_report_screen.dart';
import 'package:myapp/services/background_music_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningTabScreen extends StatefulWidget {
  @override
  _LearningTabScreenState createState() => _LearningTabScreenState();
}

class _LearningTabScreenState extends State<LearningTabScreen> {
  @override
  void initState() {
    super.initState();
    BackgroundMusicService().playBackgroundMusic();
  }

  @override
  void dispose() {
    BackgroundMusicService().stopBackgroundMusic();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchChildData() async {
    final prefs = await SharedPreferences.getInstance();
    final childName = prefs.getString('child_name');

    if (childName == null) {
      throw Exception("Child name not found in local storage.");
    }

    final response = await http.get(
      // Uri.parse('http://100.64.64.88:8000/child/$childName'),
      Uri.parse('http://192.168.1.10:8000/child/$childName'),
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
        drawer: _DrawerWidget(fetchChildData: fetchChildData),
        body: TabBarView(
          children: [_buildLearningTab(context), _buildGamesTab(context)],
        ),
      ),
    );
  }

  Widget _buildLearningTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            context,
            'assets/images/repeat_after_me.jpg',
            "Communication Skills",
            "Part 1 • Level 1 - Level 5",
            "Start Learning",
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CourseDetailScreen()),
            ),
          ),
          _buildCard(
            context,
            'assets/images/Behavioral skill.jpeg',
            "Behavioral Skills",
            "Part 2 • Level 1 - Level 3",
            "Start Learning",
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BehavioralSkillsScreen()),
            ),
          ),
          _buildCard(
            context,
            'assets/images/cognitive_skills.png',
            "Cognitive Skills",
            "Part 3 • Level 1 - Level 2",
            "Start Learning",
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CognitiveCourseDetailScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            context,
            'assets/images/repeat_after_me.jpg',
            "Communication Skills (Games and Activities)",
            "Level 1 - Level 5",
            "Play Games",
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ActivityDetailScreen()),
            ),
          ),
          _buildCard(
            context,
            'assets/images/understanding-emotion.jpeg',
            "Behavioral Skills (Games and Activities)",
            "Level 1 - Level 3",
            "Play Games",
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BehavioralSkillsActivityScreen(),
              ),
            ),
          ),
          _buildCard(
            context,
            'assets/images/cognitive_skills.png',
            "Cognitive Skills (Games and Activities)",
            "Level 1 - Level 2",
            "Play Games",
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CognitiveActivityDetailScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String imagePath,
    String title,
    String subtitle,
    String buttonText,
    VoidCallback onPressed,
  ) {
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
                onPressed: () async {
                  await BackgroundMusicService().stopBackgroundMusic();
                  onPressed();
                },
                child: Text(buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerWidget extends StatelessWidget {
  final Future<Map<String, dynamic>> Function() fetchChildData;

  const _DrawerWidget({required this.fetchChildData});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchChildData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(color: Colors.white);
                } else if (snapshot.hasError) {
                  return Text(
                    'Error loading profile',
                    style: TextStyle(color: Colors.white),
                  );
                } else if (!snapshot.hasData) {
                  return Text(
                    'No profile found',
                    style: TextStyle(color: Colors.white),
                  );
                }

                final childData = snapshot.data!;
                final imageBlob = childData['image_blob'];
                final imageBytes =
                    (imageBlob != null && imageBlob.isNotEmpty)
                        ? base64Decode(imageBlob)
                        : null;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child:
                          imageBytes != null
                              ? ClipOval(
                                child: Image.memory(
                                  imageBytes,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              )
                              : Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
                              ),
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
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgressReportScreen(),
                  ),
                ),
          ),
          ListTile(
            leading: Icon(Icons.switch_account),
            title: Text('Switch Dashboard'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('child_name');
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
