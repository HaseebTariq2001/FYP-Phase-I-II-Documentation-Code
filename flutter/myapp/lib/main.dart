
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:myapp/screens/progress_report_screen.dart';
// import 'screens/splash_screen.dart';
// import 'screens/create_account_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/assessment_screen.dart';
// import 'screens/activity_detail_screen.dart';
// import 'screens/learning_tab_screen.dart';
// import 'screens/course_detail_screen.dart';
// import 'firebase_options.dart';



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
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
//       // home: SplashScreen(),
      
//        initialRoute: '/',
//       routes: {
//         // '/create_account': (context) => CreateAccountScreen(),
//         // '/login': (context) => LoginScreen(),
//         // '/home': (context) => const HomeScreen(),
//         // '/assessment':
//             // (context) => AssessmentScreen(childName: ''), // default empty
//       '/': (context) => LearningTabScreen(),       // Home screen with 2 tabs: Course & Activity
//       '/courseDetail': (context) => CourseDetailScreen(), // Lesson flow (Repeat After Me)
//       '/activityDetail': (context) => ActivityDetailScreen(), // Activity flow 
//       // '/progressReport': (context) => ProgressReportScreen(),
//       },
//     );
//   }
// }


//for automated test
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connect to Firebase Auth Emulator (only in debug mode)
  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  runApp(const EduCareApp());
}

class EduCareApp extends StatelessWidget {
  const EduCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}

