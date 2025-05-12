import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:myapp/screens/child_profile_management.dart';
import 'Learning and lesson/child_dashboard_screen.dart';
import 'chat_screen.dart';
import 'child_profile_management_list.dart';
import 'progress_report_screen.dart';
import '../widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF3160BA);
  final Color headerColor = const Color(0xFF7BDAEB);

  bool showDropdown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showDropdown) {
          setState(() {
            showDropdown = false;
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: headerColor,
            drawer: _buildDrawer(context),
            body: SafeArea(
              child: Builder(
                builder:
                    (context) => Column(
                      children: [
                        AppHeader(
                          title: 'Dashboard',
                          showMenu: true,
                          showParent: true,
                          showParentLabel:
                              false, // ✅ Hide "Switch to child dashboard" text from AppBar

                          onMenuTap: () => Scaffold.of(context).openDrawer(),
                          onParentTap: () {
                            setState(() {
                              showDropdown = !showDropdown;
                            });
                          },
                        ),
                        const Spacer(),

                        // const SizedBox(
                        //   height: 20,
                        // ), // Push slightly below app bar
                        Image.asset(
                          'assets/images/HelloEDUBOT.png',
                          height: 138,
                        ),
                        Image.asset('assets/images/robot.png', height: 168),
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChatScreen(),
                                ),
                              );
                            },
                            child: const Text("Let’s start chatting"),
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ),

          // 👇 Dropdown under parent icon
          if (showDropdown)
            Positioned(
              // top: 80,
              top:
                  kToolbarHeight +
                  60, // Accounts for the height of the AppHeader

              right: 8,
              child: Material(
                color: Colors.white,
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showDropdown = false;
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LearningTabScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/Child-Waving.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Switch to child dashboard",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
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
                  'assets/images/logo_pic.png',
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
                    'assets/images/progress_report.svg',
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
                Container(height: 2, color: primaryColor),
              ],
            ),
          ),

          // Child Profile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    'assets/images/children-profile.svg',
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
                  // onTap: () => Navigator.pop(context),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectChildScreen(),
                      ),
                    );
                  },
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
                    'assets/images/Setting.svg',
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

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SvgPicture.asset(
                'assets/images/logout.svg',
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
                if (context.mounted) {
                  // Navigator.of(context).pushReplacementNamed('/login');
                  final GoogleSignIn _googleSignIn = GoogleSignIn();
                  await FirebaseAuth.instance.signOut();
                  await _googleSignIn.signOut();

                  // Navigator.pop(context); // Close dialog
                  Navigator.pushReplacementNamed(
                    context,
                    "/login",
                  ); // Navigate to Login Screen
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
