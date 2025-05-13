// // ignore_for_file: unused_import

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/screens/Learning%20and%20lesson/behavioral_lessons.dart';
import 'package:myapp/services/background_music_service.dart';
import 'screens/splash_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/assessment_screen.dart';
// import 'screens/Learning and lesson/';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundMusicService().checkAndStartMusic();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await BackgroundMusicService().checkAndPlayOnAppStart();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const EduBotApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🔄 Background Message: ${message.messageId}");
}

// class EduBotApp extends StatelessWidget {
//   const EduBotApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'EduCare',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SplashScreen(),
//       // home: ParentProfileScreen(),
//       //home: HomeScreen(),
//       routes: {
//         '/create_account': (context) => CreateAccountScreen(),
//         '/login': (context) => LoginScreen(),
//         '/home': (context) => const HomeScreen(),
//         '/assessment':
//             (context) => AssessmentScreen(childName: ''), // default empty
//         '/lessonDetail': (context) => BehaviorLessonScreen(),
//       },
//     );
//   }
// }

class EduBotApp extends StatefulWidget {
  const EduBotApp({super.key});

  @override
  State<EduBotApp> createState() => _EduBotAppState();
}

class _EduBotAppState extends State<EduBotApp> {
  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions (especially for iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🔐 Permission granted: ${settings.authorizationStatus}");

    // Get the token for this device
    String? token = await messaging.getToken();
    print("📲 FCM Token: $token");

    // TODO: Send this token to your Flask server if you want to trigger notifications remotely

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 Foreground message received: ${message.notification?.title}');
      // Optionally show a local notification here
    });

    // Handle when app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📬 App opened from notification: ${message.notification?.title}');
      // Navigate or perform action if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      routes: {
        '/create_account': (context) => CreateAccountScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/assessment': (context) => AssessmentScreen(childName: ''),
        '/lessonDetail': (context) => BehaviorLessonScreen(),
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


