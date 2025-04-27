// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:myapp/screens/home_screen.dart';
// import 'package:myapp/screens/login_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToNextScreen();
//   }

//   void _navigateToNextScreen() async {
//     await Future.delayed(Duration(seconds: 3)); // 3-second splash delay

// try{
//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       // User is already logged in, navigate to Home or Dashboard
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with Home Screen
//       );
//     } else {
//       // No user logged in, navigate to Create Account Screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     }
//   } catch (e) {
//       // Fallback to login in case of error
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: Image.asset(
//               "assets/background.png",
//               fit: BoxFit.cover,
//             ),
//           ),

//           // Semi-transparent overlay
//           Container(
//             color: Colors.blue.withOpacity(0.4),
//           ),

//           // Centered Content
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Logo Image
//                 Image.asset(
//                   "assets/logo_pic.png", // Make sure this image exists in assets
//                    width: 350,
//                 ),

//                 // Loading Indicator
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // 3-second splash

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User logged in
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // No user logged in
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/background.png", fit: BoxFit.cover),
          ),
          Container(color: Colors.blue.withOpacity(0.4)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo_pic.png", width: 350),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
