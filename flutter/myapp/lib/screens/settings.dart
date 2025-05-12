// import 'package:flutter/material.dart';

// import 'add_child_profile_screen.dart';
// import 'parent_profile_update.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   double _volume = 50.0; // Default volume level (0 to 100)
//   bool _isMusicOn = false; // Background music toggle state

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white, // White back icon
//           ),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const HomeScreen()),
//             ); // Navigate to HomeScreen
//           },
//         ),
//         title: const Text(
//           'Settings',
//           style: TextStyle(
//             color: Colors.white, // White title
//             fontWeight: FontWeight.bold, // Bold title
//           ),
//         ),
//         centerTitle: true, // Center the title
//         backgroundColor: Colors.blue,
//       ),
//       body: Container(
//         color: const Color(0xFFE0F7FA), // Light cyan background
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             // Profile Section
//             const Text(
//               'Profile',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ListTile(
//               leading: const Icon(Icons.edit),
//               title: const Text('Edit Profile'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ParentProfileScreen(),
//                   ),
//                 );
//               },
//               tileColor: Colors.grey[200], // Grey background for list tile
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ListTile(
//               leading: const Icon(Icons.person_add),
//               title: const Text('Add new Child'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const AddChildProfileScreen(),
//                   ),
//                 );
//               },
//               tileColor: Colors.grey[200], // Grey background for list tile
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // General Section
//             const Text(
//               'General',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ListTile(
//               leading: const Icon(Icons.volume_up),
//               title: Row(
//                 children: [
//                   const Text('Sound'),
//                   const Spacer(),
//                   Slider(
//                     value: _volume,
//                     min: 0,
//                     max: 100,
//                     onChanged: (value) {
//                       setState(() {
//                         _volume = value;
//                       });
//                       // Add logic to adjust the app's sound volume here
//                     },
//                   ),
//                 ],
//               ),
//               tileColor: Colors.grey[200], // Grey background for list tile
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ListTile(
//               leading: const Icon(Icons.music_note),
//               title: Row(
//                 children: [
//                   const Text('Background Music'),
//                   const Spacer(),
//                   Switch(
//                     value: _isMusicOn,
//                     onChanged: (value) {
//                       setState(() {
//                         _isMusicOn = value;
//                       });
//                       // Add logic to enable/disable background music here
//                     },
//                   ),
//                 ],
//               ),
//               tileColor: Colors.grey[200], // Grey background for list tile
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ListTile(
//               leading: const Icon(Icons.notifications),
//               title: Row(
//                 children: [
//                   const Text('Notifications'),
//                   const Spacer(),
//                   Switch(
//                     value: true, // Default to true as per the image
//                     onChanged: (value) {
//                       // Add logic to enable/disable notifications here
//                     },
//                   ),
//                 ],
//               ),
//               tileColor: Colors.grey[200], // Grey background for list tile
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ListTile(
//               leading: const Icon(Icons.support_agent),
//               title: const Text('Support'),
//               trailing: const Icon(Icons.chevron_right),
//               onTap: () {
//                 // Add navigation to Support screen if needed
//               },
//               tileColor: Colors.grey[200], // Grey background for list tile
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ListTile(
//               leading: const Icon(Icons.privacy_tip),
//               title: const Text('Privacy policy'),
//               trailing: const Icon(Icons.chevron_right),
//               onTap: () {
//                 // Add navigation to Privacy Policy screen if needed
//               },
//               tileColor: Colors.grey[200], // Grey background for list tile
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Placeholder for HomeScreen (assuming it exists in your project)
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }

// import 'package:flutter/material.dart';

// import 'add_child_profile_screen.dart';
// import 'parent_profile_update.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   double _volume = 50.0; // Default volume level (0 to 100)
//   bool _isMusicOn = false; // Background music toggle state

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white, // White back icon
//           ),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const HomeScreen()),
//             ); // Navigate to HomeScreen
//           },
//         ),
//         title: const Text(
//           'Settings',
//           style: TextStyle(
//             color: Colors.white, // White title
//             fontWeight: FontWeight.bold, // Bold title
//           ),
//         ),
//         centerTitle: true, // Center the title
//         backgroundColor: Colors.blue,
//       ),
//       body: Container(
//         color: const Color(0xFFE0F7FA), // Light cyan background
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             // Profile Section
//             const Text(
//               'Profile',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               color: const Color.fromARGB(
//                 255,
//                 169,
//                 166,
//                 166,
//               ), // Grey background for list tile
//               child: ListTile(
//                 leading: const Icon(Icons.edit),
//                 title: const Text('Edit Profile'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ParentProfileScreen(),
//                     ),
//                   );
//                 },
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 8.0,
//                   horizontal: 16.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               color: Colors.grey[200], // Grey background for list tile
//               child: ListTile(
//                 leading: const Icon(Icons.person_add),
//                 title: const Text('Add new Child'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AddChildProfileScreen(),
//                     ),
//                   );
//                 },
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 8.0,
//                   horizontal: 16.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // General Section
//             const Text(
//               'General',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               color: Colors.grey[200], // Grey background for list tile
//               child: ListTile(
//                 leading: const Icon(Icons.volume_up),
//                 title: Row(
//                   children: [
//                     const Text('Sound'),
//                     const Spacer(),
//                     SizedBox(
//                       width: 150,
//                       child: Slider(
//                         value: _volume,
//                         min: 0,
//                         max: 100,
//                         activeColor: Colors.purple,
//                         inactiveColor: Colors.grey[300],
//                         onChanged: (value) {
//                           setState(() {
//                             _volume = value;
//                           });
//                           // Add logic to adjust the app's sound volume here
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 8.0,
//                   horizontal: 16.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               color: Colors.grey[200], // Grey background for list tile
//               child: ListTile(
//                 leading: const Icon(Icons.music_note),
//                 title: Row(
//                   children: [
//                     const Text('Background Music'),
//                     const Spacer(),
//                     Switch(
//                       value: _isMusicOn,
//                       activeColor: Colors.purple,
//                       onChanged: (value) {
//                         setState(() {
//                           _isMusicOn = value;
//                         });
//                         // Add logic to enable/disable background music here
//                       },
//                     ),
//                   ],
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 8.0,
//                   horizontal: 16.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               color: Colors.grey[200], // Grey background for list tile
//               child: ListTile(
//                 leading: const Icon(Icons.notifications),
//                 title: Row(
//                   children: [
//                     const Text('Notifications'),
//                     const Spacer(),
//                     Switch(
//                       value: true, // Default to true as per the image
//                       activeColor: Colors.purple,
//                       onChanged: (value) {
//                         // Add logic to enable/disable notifications here
//                       },
//                     ),
//                   ],
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 8.0,
//                   horizontal: 16.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               color: Colors.grey[200], // Grey background for list tile
//               child: ListTile(
//                 leading: const Icon(Icons.support_agent),
//                 title: const Text('Support'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onTap: () {
//                   // Add navigation to Support screen if needed
//                 },
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 8.0,
//                   horizontal: 16.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               color: Colors.grey[200], // Grey background for list tile
//               child: ListTile(
//                 leading: const Icon(Icons.privacy_tip),
//                 title: const Text('Privacy policy'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onTap: () {
//                   // Add navigation to Privacy Policy screen if needed
//                 },
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 8.0,
//                   horizontal: 16.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Placeholder for HomeScreen (assuming it exists in your project)
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }

import 'package:flutter/material.dart';

import 'add_child_profile_screen.dart';
import 'feedback_screen.dart';
import 'home_screen.dart';
import 'parent_profile_update.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volume = 50.0; // Default volume level (0 to 100)
  bool _isMusicOn = false; // Background music toggle state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // White back icon
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white, // White title
            fontWeight: FontWeight.bold, // Bold title
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: Color(0xFF7BDAEB),
      ),
      body: Container(
        color: const Color(0xFFE0F7FA), // Light cyan background
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Section
            const Text(
              'Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Lighter greyish color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParentProfileScreen(),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Lighter greyish color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Add new Child'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddChildProfileScreen(),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // General Section
            const Text(
              'General',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Lighter greyish color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
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
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                          });
                          // Add logic to adjust the app's sound volume here
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
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Lighter greyish color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: ListTile(
                leading: const Icon(Icons.music_note),
                title: Row(
                  children: [
                    const Text('Background Music'),
                    const Spacer(),
                    Switch(
                      value: _isMusicOn,
                      activeColor: Colors.purple,
                      onChanged: (value) {
                        setState(() {
                          _isMusicOn = value;
                        });
                        // Add logic to enable/disable background music here
                      },
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Lighter greyish color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: Row(
                  children: [
                    const Text('Notifications'),
                    const Spacer(),
                    Switch(
                      value: true, // Default to true as per the image
                      activeColor: Colors.purple,
                      onChanged: (value) {
                        // Add logic to enable/disable notifications here
                      },
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Lighter greyish color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: ListTile(
                leading: const Icon(Icons.support_agent),
                title: const Text('Support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackScreen(),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Lighter greyish color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Add navigation to Privacy Policy screen if needed
                },
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for HomeScreen (assuming it exists in your project)
