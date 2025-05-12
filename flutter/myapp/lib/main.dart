// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/screens/Learning%20and%20lesson/behavioral_lessons.dart';
import 'package:myapp/screens/activity_screens/emotion_sorting_screen.dart'
    show EmotionSortingScreen;
import 'package:myapp/screens/activity_screens/match_emotion_activity_screen.dart'
    show MatchEmotionActivityScreen;
import 'package:myapp/screens/activity_screens/tap_good_activity.dart'
    show TapGoodBehaviorActivityScreen;
import 'package:myapp/screens/progress_report_screen.dart';
import 'screens/Learning and lesson/lesson_screen.dart';
import 'screens/parent_profile_update.dart';
import 'screens/splash_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/assessment_screen.dart';
import 'screens/activity_screens/activity_detail_screen.dart';
import 'screens/Learning and lesson/child_dashboard_screen.dart';
// import 'screens/Learning and lesson/';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: SplashScreen(),
      // home: ParentProfileScreen(),
      routes: {
        '/create_account': (context) => CreateAccountScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/assessment':
            (context) => AssessmentScreen(childName: ''), // default empty
        '/lessonDetail': (context) => BehaviorLessonScreen(),
        '/BehavioralActivities': (context) => MatchEmotionActivityScreen(),
        '/emotionsortingActivity': (context) => EmotionSortingScreen(),
        '/tapgoodactivity': (context) => TapGoodBehaviorActivityScreen(),
      },
    );
  }
}


//for automated test
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'screens/login_screen.dart';
// import 'firebase_options.dart'; 

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // Connect to Firebase Auth Emulator (only in debug mode)
//   if (kDebugMode) {
//     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
//   }

//   runApp(const EduCareApp());
// }

// class EduCareApp extends StatelessWidget {
//   const EduCareApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'EduCare',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: const LoginScreen(),
//     );
//   }
// }

