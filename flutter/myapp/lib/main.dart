// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'screens/splash_screen.dart';
// import 'screens/create_account_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/assessment_screen.dart';
// //import 'screens/result_screen.dart'; // After assessment

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // ✅ Now the import is used
//   runApp(const EduBotApp());
// }

// class EduBotApp extends StatelessWidget {
//   const EduBotApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'EduCare',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SplashScreen(), // or LoginScreen if skipping splash
//       routes: {
//         '/create_account': (context) => CreateAccountScreen(),
//         '/login': (context) => LoginScreen(),
//         '/chat': (context) => const HomeScreen(), // EduBot
//         '/assessment': (context) => const AssessmentScreen(childName: "Child"),
//         // '/result': (context) => const ResultScreen(), // Learning modules/games
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/assessment_screen.dart';
import 'screens/learning_tab_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/activity_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EduBotApp());
}

class EduBotApp extends StatelessWidget {
  const EduBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: SplashScreen(),
      initialRoute: '/',
      routes: {
        // '/create_account': (context) => CreateAccountScreen(),
        // '/login': (context) => LoginScreen(),
        // '/home': (context) => const HomeScreen(),
        // '/assessment':
        //     (context) => AssessmentScreen(childName: ''), // default empty
      '/': (context) => LearningTabScreen(),       // Home screen with 2 tabs: Course & Activity
      '/courseDetail': (context) => CourseDetailScreen(), // Lesson flow (Repeat After Me)
      '/activityDetail': (context) => ActivityDetailScreen(), // Activity flow   
      },
    );
  }
}
