// import 'package:flutter/material.dart';
// import 'chat_screen.dart';
// import '../widgets/app_header.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue[100],
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Updated AppHeader (already contains bigger Dashboard and icons above text)
//             const AppHeader(title: 'Dashboard', showMenu: true, showParent: true),

//             const Spacer(),

//             // "HELLO I'M EDUBOT" image
//             Image.asset('assets/HelloEDUBOT.png', height: 138),

//             // Chatbot image
//             Image.asset('assets/robot.png', height: 168, width: 168),

//             const SizedBox(height: 20),

//             // Greeting text
//             const Text(
//               'Nice to meet you! 😊\nHow can I help you?',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),

//             const Spacer(),

//             // Start Chatting Button
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size.fromHeight(50),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//                 onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const ChatScreen()),
//                 ),
//                 child: const Text("Let’s start chatting"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import '../widgets/app_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color primaryColor = const Color(0xFF3160BA);
  final Color headerColor = const Color(0xFF7BDAEB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: headerColor,

      // ✅ Drawer
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header
            Container(
              height: 130,
              color: headerColor,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo_pic.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'EDUCARE',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Progress Report
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'assets/progress_report.svg',
                      height: 30,
                      width: 30,
                      colorFilter: ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: Text(
                      'Progress Report',
                      style: TextStyle(color: primaryColor),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  Container(height: 2, color: primaryColor),
                ],
              ),
            ),

            // Child's Profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'assets/children-profile.svg',
                      height: 30,
                      width: 30,
                      colorFilter: ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: Text(
                      "Child's Profile",
                      style: TextStyle(color: primaryColor),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  Container(height: 2, color: primaryColor),
                ],
              ),
            ),

            // Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'assets/Setting.svg',
                      height: 30,
                      width: 30,
                      colorFilter: ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(color: primaryColor),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  Container(height: 2, color: primaryColor),
                ],
              ),
            ),

            const Spacer(),

            // ✅ Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset(
                  'assets/logout.svg',
                  height: 30,
                  width: 30,
                  colorFilter: const ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
              ),
            ),
          ],
        ),
      ),

      // ✅ Main Body
      body: SafeArea(
        child: Builder(
          builder:
              (context) => Column(
                children: [
                  AppHeader(
                    title: 'Dashboard',
                    showMenu: true,
                    showParent: true,
                    onMenuTap: () => Scaffold.of(context).openDrawer(),
                  ),

                  const Spacer(),

                  Image.asset('assets/HelloEDUBOT.png', height: 138),
                  Image.asset('assets/robot.png', height: 168, width: 168),

                  const SizedBox(height: 20),

                  const Text(
                    'Nice to meet you! 😊\nHow can I help you?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChatScreen(),
                            ),
                          ),
                      child: const Text("Let’s start chatting"),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
