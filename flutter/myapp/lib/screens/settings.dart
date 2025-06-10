// // import 'package:flutter/material.dart';

// // import 'add_child_profile_screen.dart';
// // import 'parent_profile_update.dart';

// // class SettingsScreen extends StatefulWidget {
// //   const SettingsScreen({super.key});

// //   @override
// //   State<SettingsScreen> createState() => _SettingsScreenState();
// // }

// // class _SettingsScreenState extends State<SettingsScreen> {
// //   double _volume = 50.0; // Default volume level (0 to 100)
// //   bool _isMusicOn = false; // Background music toggle state

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: IconButton(
// //           icon: const Icon(
// //             Icons.arrow_back,
// //             color: Colors.white, // White back icon
// //           ),
// //           onPressed: () {
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(builder: (context) => const HomeScreen()),
// //             ); // Navigate to HomeScreen
// //           },
// //         ),
// //         title: const Text(
// //           'Settings',
// //           style: TextStyle(
// //             color: Colors.white, // White title
// //             fontWeight: FontWeight.bold, // Bold title
// //           ),
// //         ),
// //         centerTitle: true, // Center the title
// //         backgroundColor: Colors.blue,
// //       ),
// //       body: Container(
// //         color: const Color(0xFFE0F7FA), // Light cyan background
// //         padding: const EdgeInsets.all(16.0),
// //         child: ListView(
// //           children: [
// //             // Profile Section
// //             const Text(
// //               'Profile',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 8),
// //             ListTile(
// //               leading: const Icon(Icons.edit),
// //               title: const Text('Edit Profile'),
// //               onTap: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => ParentProfileScreen(),
// //                   ),
// //                 );
// //               },
// //               tileColor: Colors.grey[200], // Grey background for list tile
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8.0),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             ListTile(
// //               leading: const Icon(Icons.person_add),
// //               title: const Text('Add new Child'),
// //               onTap: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => const AddChildProfileScreen(),
// //                   ),
// //                 );
// //               },
// //               tileColor: Colors.grey[200], // Grey background for list tile
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8.0),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             // General Section
// //             const Text(
// //               'General',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 8),
// //             ListTile(
// //               leading: const Icon(Icons.volume_up),
// //               title: Row(
// //                 children: [
// //                   const Text('Sound'),
// //                   const Spacer(),
// //                   Slider(
// //                     value: _volume,
// //                     min: 0,
// //                     max: 100,
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _volume = value;
// //                       });
// //                       // Add logic to adjust the app's sound volume here
// //                     },
// //                   ),
// //                 ],
// //               ),
// //               tileColor: Colors.grey[200], // Grey background for list tile
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8.0),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             ListTile(
// //               leading: const Icon(Icons.music_note),
// //               title: Row(
// //                 children: [
// //                   const Text('Background Music'),
// //                   const Spacer(),
// //                   Switch(
// //                     value: _isMusicOn,
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _isMusicOn = value;
// //                       });
// //                       // Add logic to enable/disable background music here
// //                     },
// //                   ),
// //                 ],
// //               ),
// //               tileColor: Colors.grey[200], // Grey background for list tile
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8.0),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             ListTile(
// //               leading: const Icon(Icons.notifications),
// //               title: Row(
// //                 children: [
// //                   const Text('Notifications'),
// //                   const Spacer(),
// //                   Switch(
// //                     value: true, // Default to true as per the image
// //                     onChanged: (value) {
// //                       // Add logic to enable/disable notifications here
// //                     },
// //                   ),
// //                 ],
// //               ),
// //               tileColor: Colors.grey[200], // Grey background for list tile
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8.0),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             ListTile(
// //               leading: const Icon(Icons.support_agent),
// //               title: const Text('Support'),
// //               trailing: const Icon(Icons.chevron_right),
// //               onTap: () {
// //                 // Add navigation to Support screen if needed
// //               },
// //               tileColor: Colors.grey[200], // Grey background for list tile
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8.0),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             ListTile(
// //               leading: const Icon(Icons.privacy_tip),
// //               title: const Text('Privacy policy'),
// //               trailing: const Icon(Icons.chevron_right),
// //               onTap: () {
// //                 // Add navigation to Privacy Policy screen if needed
// //               },
// //               tileColor: Colors.grey[200], // Grey background for list tile
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8.0),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Placeholder for HomeScreen (assuming it exists in your project)
// // class HomeScreen extends StatelessWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Scaffold();
// //   }
// // }

// // import 'package:flutter/material.dart';

// // import 'add_child_profile_screen.dart';
// // import 'parent_profile_update.dart';

// // class SettingsScreen extends StatefulWidget {
// //   const SettingsScreen({super.key});

// //   @override
// //   State<SettingsScreen> createState() => _SettingsScreenState();
// // }

// // class _SettingsScreenState extends State<SettingsScreen> {
// //   double _volume = 50.0; // Default volume level (0 to 100)
// //   bool _isMusicOn = false; // Background music toggle state

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: IconButton(
// //           icon: const Icon(
// //             Icons.arrow_back,
// //             color: Colors.white, // White back icon
// //           ),
// //           onPressed: () {
// //             Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(builder: (context) => const HomeScreen()),
// //             ); // Navigate to HomeScreen
// //           },
// //         ),
// //         title: const Text(
// //           'Settings',
// //           style: TextStyle(
// //             color: Colors.white, // White title
// //             fontWeight: FontWeight.bold, // Bold title
// //           ),
// //         ),
// //         centerTitle: true, // Center the title
// //         backgroundColor: Colors.blue,
// //       ),
// //       body: Container(
// //         color: const Color(0xFFE0F7FA), // Light cyan background
// //         padding: const EdgeInsets.all(16.0),
// //         child: ListView(
// //           children: [
// //             // Profile Section
// //             const Text(
// //               'Profile',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               color: const Color.fromARGB(
// //                 255,
// //                 169,
// //                 166,
// //                 166,
// //               ), // Grey background for list tile
// //               child: ListTile(
// //                 leading: const Icon(Icons.edit),
// //                 title: const Text('Edit Profile'),
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => ParentProfileScreen(),
// //                     ),
// //                   );
// //                 },
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8.0),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               color: Colors.grey[200], // Grey background for list tile
// //               child: ListTile(
// //                 leading: const Icon(Icons.person_add),
// //                 title: const Text('Add new Child'),
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => const AddChildProfileScreen(),
// //                     ),
// //                   );
// //                 },
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8.0),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             // General Section
// //             const Text(
// //               'General',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               color: Colors.grey[200], // Grey background for list tile
// //               child: ListTile(
// //                 leading: const Icon(Icons.volume_up),
// //                 title: Row(
// //                   children: [
// //                     const Text('Sound'),
// //                     const Spacer(),
// //                     SizedBox(
// //                       width: 150,
// //                       child: Slider(
// //                         value: _volume,
// //                         min: 0,
// //                         max: 100,
// //                         activeColor: Colors.purple,
// //                         inactiveColor: Colors.grey[300],
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _volume = value;
// //                           });
// //                           // Add logic to adjust the app's sound volume here
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8.0),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               color: Colors.grey[200], // Grey background for list tile
// //               child: ListTile(
// //                 leading: const Icon(Icons.music_note),
// //                 title: Row(
// //                   children: [
// //                     const Text('Background Music'),
// //                     const Spacer(),
// //                     Switch(
// //                       value: _isMusicOn,
// //                       activeColor: Colors.purple,
// //                       onChanged: (value) {
// //                         setState(() {
// //                           _isMusicOn = value;
// //                         });
// //                         // Add logic to enable/disable background music here
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8.0),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               color: Colors.grey[200], // Grey background for list tile
// //               child: ListTile(
// //                 leading: const Icon(Icons.notifications),
// //                 title: Row(
// //                   children: [
// //                     const Text('Notifications'),
// //                     const Spacer(),
// //                     Switch(
// //                       value: true, // Default to true as per the image
// //                       activeColor: Colors.purple,
// //                       onChanged: (value) {
// //                         // Add logic to enable/disable notifications here
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8.0),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               color: Colors.grey[200], // Grey background for list tile
// //               child: ListTile(
// //                 leading: const Icon(Icons.support_agent),
// //                 title: const Text('Support'),
// //                 trailing: const Icon(Icons.chevron_right),
// //                 onTap: () {
// //                   // Add navigation to Support screen if needed
// //                 },
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8.0),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               color: Colors.grey[200], // Grey background for list tile
// //               child: ListTile(
// //                 leading: const Icon(Icons.privacy_tip),
// //                 title: const Text('Privacy policy'),
// //                 trailing: const Icon(Icons.chevron_right),
// //                 onTap: () {
// //                   // Add navigation to Privacy Policy screen if needed
// //                 },
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8.0),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Placeholder for HomeScreen (assuming it exists in your project)
// // class HomeScreen extends StatelessWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Scaffold();
// //   }
// // }

// // import 'package:flutter/material.dart';

// // import 'add_child_profile_screen.dart';
// // import 'feedback_screen.dart';
// // import 'home_screen.dart';
// // import 'parent_profile_update.dart';

// // class SettingsScreen extends StatefulWidget {
// //   const SettingsScreen({super.key});

// //   @override
// //   State<SettingsScreen> createState() => _SettingsScreenState();
// // }

// // class _SettingsScreenState extends State<SettingsScreen> {
// //   double _volume = 50.0; // Default volume level (0 to 100)
// //   bool _isMusicOn = false; // Background music toggle state

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: IconButton(
// //           icon: const Icon(
// //             Icons.arrow_back,
// //             color: Colors.white, // White back icon
// //           ),
// //           onPressed: () {
// //             Navigator.pushAndRemoveUntil(
// //               context,
// //               MaterialPageRoute(builder: (context) => HomeScreen()),
// //               (route) => false,
// //             );
// //           },
// //         ),
// //         title: const Text(
// //           'Settings',
// //           style: TextStyle(
// //             color: Colors.white, // White title
// //             fontWeight: FontWeight.bold, // Bold title
// //           ),
// //         ),
// //         centerTitle: true, // Center the title
// //         backgroundColor: Color(0xFF7BDAEB),
// //       ),
// //       body: Container(
// //         color: const Color(0xFFE0F7FA), // Light cyan background
// //         padding: const EdgeInsets.all(16.0),
// //         child: ListView(
// //           children: [
// //             // Profile Section
// //             const Text(
// //               'Profile',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300], // Lighter greyish color
// //                 borderRadius: BorderRadius.circular(12.0), // Rounded corners
// //               ),
// //               child: ListTile(
// //                 leading: const Icon(Icons.edit),
// //                 title: const Text('Edit Profile'),
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => ParentProfileScreen(),
// //                     ),
// //                   );
// //                 },
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300], // Lighter greyish color
// //                 borderRadius: BorderRadius.circular(12.0), // Rounded corners
// //               ),
// //               child: ListTile(
// //                 leading: const Icon(Icons.person_add),
// //                 title: const Text('Add new Child'),
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => const AddChildProfileScreen(),
// //                     ),
// //                   );
// //                 },
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             // General Section
// //             const Text(
// //               'General',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300], // Lighter greyish color
// //                 borderRadius: BorderRadius.circular(12.0), // Rounded corners
// //               ),
// //               child: ListTile(
// //                 leading: const Icon(Icons.volume_up),
// //                 title: Row(
// //                   children: [
// //                     const Text('Sound'),
// //                     const Spacer(),
// //                     SizedBox(
// //                       width: 150,
// //                       child: Slider(
// //                         value: _volume,
// //                         min: 0,
// //                         max: 100,
// //                         activeColor: Colors.purple,
// //                         inactiveColor: Colors.grey[400],
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _volume = value;
// //                           });
// //                           // Add logic to adjust the app's sound volume here
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300], // Lighter greyish color
// //                 borderRadius: BorderRadius.circular(12.0), // Rounded corners
// //               ),
// //               child: ListTile(
// //                 leading: const Icon(Icons.music_note),
// //                 title: Row(
// //                   children: [
// //                     const Text('Background Music'),
// //                     const Spacer(),
// //                     Switch(
// //                       value: _isMusicOn,
// //                       activeColor: Colors.purple,
// //                       onChanged: (value) {
// //                         setState(() {
// //                           _isMusicOn = value;
// //                         });
// //                         // Add logic to enable/disable background music here
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300], // Lighter greyish color
// //                 borderRadius: BorderRadius.circular(12.0), // Rounded corners
// //               ),
// //               child: ListTile(
// //                 leading: const Icon(Icons.notifications),
// //                 title: Row(
// //                   children: [
// //                     const Text('Notifications'),
// //                     const Spacer(),
// //                     Switch(
// //                       value: true, // Default to true as per the image
// //                       activeColor: Colors.purple,
// //                       onChanged: (value) {
// //                         // Add logic to enable/disable notifications here
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300], // Lighter greyish color
// //                 borderRadius: BorderRadius.circular(12.0), // Rounded corners
// //               ),
// //               child: ListTile(
// //                 leading: const Icon(Icons.support_agent),
// //                 title: const Text('Support'),
// //                 trailing: const Icon(Icons.chevron_right),
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => const FeedbackScreen(),
// //                     ),
// //                   );
// //                 },
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300], // Lighter greyish color
// //                 borderRadius: BorderRadius.circular(12.0), // Rounded corners
// //               ),
// //               child: ListTile(
// //                 leading: const Icon(Icons.privacy_tip),
// //                 title: const Text('Privacy policy'),
// //                 trailing: const Icon(Icons.chevron_right),
// //                 onTap: () {
// //                   // Add navigation to Privacy Policy screen if needed
// //                 },
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   vertical: 8.0,
// //                   horizontal: 16.0,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Placeholder for HomeScreen (assuming it exists in your project)

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'add_child_profile_screen.dart';
// import 'feedback_screen.dart';
// import 'home_screen.dart';
// import 'parent_profile_update.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   double _volume = 50.0;
//   bool _isMusicOn = false;
//   bool _notificationsEnabled = true; // ✅ added

//   @override
//   void initState() {
//     super.initState();
//     _loadNotificationPreference();
//   }

//   Future<void> _loadNotificationPreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _notificationsEnabled = prefs.getBool('notifications_on') ?? true;
//     });
//   }

//   Future<void> _toggleNotifications(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('notifications_on', value);
//     setState(() {
//       _notificationsEnabled = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const HomeScreen()),
//               (route) => false,
//             );
//           },
//         ),
//         title: const Text(
//           'Settings',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF7BDAEB),
//       ),
//       body: Container(
//         color: const Color(0xFFE0F7FA),
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             const Text('Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             _buildTile(
//               icon: Icons.edit,
//               title: 'Edit Profile',
//               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ParentProfileScreen())),
//             ),
//             const SizedBox(height: 8),
//             _buildTile(
//               icon: Icons.person_add,
//               title: 'Add new Child',
//               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddChildProfileScreen())),
//             ),
//             const SizedBox(height: 16),
//             const Text('General', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             _buildVolumeTile(),
//             const SizedBox(height: 8),
//             _buildSwitchTile(
//               icon: Icons.music_note,
//               title: 'Background Music',
//               value: _isMusicOn,
//               onChanged: (value) => setState(() => _isMusicOn = value),
//             ),
//             const SizedBox(height: 8),
//             _buildSwitchTile(
//               icon: Icons.notifications,
//               title: 'Notifications',
//               value: _notificationsEnabled,
//               onChanged: _toggleNotifications,
//             ),
//             const SizedBox(height: 8),
//             _buildTile(
//               icon: Icons.support_agent,
//               title: 'Support',
//               trailingIcon: Icons.chevron_right,
//               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackScreen())),
//             ),
//             const SizedBox(height: 8),
//             _buildTile(
//               icon: Icons.privacy_tip,
//               title: 'Privacy Policy',
//               trailingIcon: Icons.chevron_right,
//               onTap: () {}, // Add privacy policy navigation
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTile({required IconData icon, required String title, VoidCallback? onTap, IconData? trailingIcon}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: ListTile(
//         leading: Icon(icon),
//         title: Text(title),
//         trailing: trailingIcon != null ? Icon(trailingIcon) : null,
//         onTap: onTap,
//         contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       ),
//     );
//   }

//   Widget _buildSwitchTile({required IconData icon, required String title, required bool value, required ValueChanged<bool> onChanged}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: ListTile(
//         leading: Icon(icon),
//         title: Row(
//           children: [
//             Text(title),
//             const Spacer(),
//             Switch(
//               value: value,
//               activeColor: Colors.purple,
//               onChanged: onChanged,
//             ),
//           ],
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       ),
//     );
//   }

//   Widget _buildVolumeTile() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: ListTile(
//         leading: const Icon(Icons.volume_up),
//         title: Row(
//           children: [
//             const Text('Sound'),
//             const Spacer(),
//             SizedBox(
//               width: 150,
//               child: Slider(
//                 value: _volume,
//                 min: 0,
//                 max: 100,
//                 activeColor: Colors.purple,
//                 inactiveColor: Colors.grey[400],
//                 onChanged: (value) {
//                   setState(() {
//                     _volume = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/background_music_service.dart';
import 'add_child_profile_screen.dart';
import 'feedback_screen.dart';
import 'home_screen.dart';
import 'parent_profile_update.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volume = 50.0;
  bool _isMusicOn = false;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
    _loadMusicPreference();
    _loadVolumePreference(); // 👈 Add this line
  }

  Future<void> _loadVolumePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _volume = prefs.getDouble('volume') ?? 50.0;
    });
  }

  Future<void> _saveVolumePreference(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', value);
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_on') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_on', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _loadMusicPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMusicOn = prefs.getBool('background_music_on') ?? false;
    });

    if (_isMusicOn) {
      await BackgroundMusicService().playBackgroundMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF7BDAEB),
      ),
      body: Container(
        color: const Color(0xFFE0F7FA),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTile(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParentProfileScreen(),
                    ),
                  ),
            ),
            const SizedBox(height: 8),
            _buildTile(
              icon: Icons.person_add,
              title: 'Add new Child',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddChildProfileScreen(),
                    ),
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'General',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildVolumeTile(),
            const SizedBox(height: 8),
            _buildSwitchTile(
              icon: Icons.music_note,
              title: 'Background Music',
              value: _isMusicOn,
              onChanged: (value) async {
                setState(() => _isMusicOn = value);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool(
                  'background_music_on',
                  _isMusicOn,
                ); // ✅ fixed key

                if (_isMusicOn) {
                  await BackgroundMusicService().playBackgroundMusic();
                } else {
                  await BackgroundMusicService().stopBackgroundMusic();
                }
              },
            ),
            const SizedBox(height: 8),
            _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Notifications',
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
            const SizedBox(height: 8),
            _buildTile(
              icon: Icons.support_agent,
              title: 'Support',
              trailingIcon: Icons.chevron_right,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackScreen(),
                    ),
                  ),
            ),
            const SizedBox(height: 8),
            _buildTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              trailingIcon: Icons.chevron_right,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    IconData? trailingIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailingIcon != null ? Icon(trailingIcon) : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Row(
          children: [
            Text(title),
            const Spacer(),
            Switch(
              value: value,
              activeColor: Colors.purple,
              onChanged: onChanged,
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
      ),
    );
  }

  Widget _buildVolumeTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: const Icon(Icons.volume_up),
        title: Row(
          children: [
            const Text('Sound'),
            const Spacer(),
            SizedBox(
              width: 150,
              child: Slider(
                value: _volume,
                min: 0,
                max: 100,
                activeColor: Colors.purple,
                inactiveColor: Colors.grey[400],
                onChanged: (value) async {
                  setState(() {
                    _volume = value;
                  });
                  await BackgroundMusicService().setVolume(_volume / 100);
                  await _saveVolumePreference(
                    _volume,
                  ); // 👈 Save the updated volume
                },
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
      ),
    );
  }
}
