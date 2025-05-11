// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ChildProfileScreen extends StatefulWidget {
//   final String childId;

//   ChildProfileScreen({required this.childId});

//   @override
//   _ChildProfileScreenState createState() => _ChildProfileScreenState();
// }

// class _ChildProfileScreenState extends State<ChildProfileScreen> {
//   late String name = '';
//   late String password = '';

//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchChildData();
//   }

//   Future<void> fetchChildData() async {
//     final response = await http.get(
//       Uri.parse('http://192.168.1.6/child/${widget.childId}'),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         name = data['name'];
//         password = data['password'];
//         _passwordController.text = password;
//       });
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to fetch profile')));
//     }
//   }

//   Future<void> updateProfile() async {
//     final response = await http.put(
//       Uri.parse('http://192.168.1.6/child/${widget.childId}'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'name': name, 'password': _passwordController.text}),
//     );
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to update profile')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [IconButton(icon: Icon(Icons.menu), onPressed: () {})],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.grey,
//               child: Icon(Icons.person, size: 50),
//             ),
//             SizedBox(height: 10),
//             Text(
//               name,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             _buildEditableField(
//               'Password',
//               _passwordController,
//               Icons.edit,
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: updateProfile,
//               child: Text('Update Profile'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableField(
//     String label,
//     TextEditingController controller,
//     IconData icon, {
//     bool obscureText = false,
//   }) {
//     return ListTile(
//       leading: Icon(Icons.lock_outline),
//       title: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(labelText: label, border: InputBorder.none),
//       ),
//       trailing: IconButton(
//         icon: Icon(icon),
//         onPressed: () {
//           setState(() {
//             if (label == 'Password') password = controller.text;
//           });
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ChildProfileScreen extends StatefulWidget {
//   @override
//   _ChildProfileScreenState createState() => _ChildProfileScreenState();
// }

// class _ChildProfileScreenState extends State<ChildProfileScreen> {
//   late String name = '';
//   late String password = '';

//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchChildData();
//   }

//   Future<void> fetchChildData() async {
//     final response = await http.get(Uri.parse('http://192.168.1.6:8000/child'));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         name = data['name'];
//         password = data['password'];
//         _passwordController.text = password;
//       });
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to fetch profile')));
//     }
//   }

//   Future<void> updateProfile() async {
//     final response = await http.put(
//       Uri.parse('http://192.168.1.6:8000/child'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'name': name, 'password': _passwordController.text}),
//     );
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to update profile')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [IconButton(icon: Icon(Icons.menu), onPressed: () {})],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.grey,
//               child: Icon(Icons.person, size: 50),
//             ),
//             SizedBox(height: 10),
//             Text(
//               name,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             _buildEditableField(
//               'Password',
//               _passwordController,
//               Icons.edit,
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: updateProfile,
//               child: Text('Update Profile'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableField(
//     String label,
//     TextEditingController controller,
//     IconData icon, {
//     bool obscureText = false,
//   }) {
//     return ListTile(
//       leading: Icon(Icons.lock_outline),
//       title: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(labelText: label, border: InputBorder.none),
//       ),
//       trailing: IconButton(
//         icon: Icon(icon),
//         onPressed: () {
//           setState(() {
//             if (label == 'Password') password = controller.text;
//           });
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChildProfileScreen extends StatefulWidget {
  @override
  _ChildProfileScreenState createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  late String name = '';
  late String password = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchChildData();
  }

  Future<void> fetchChildData() async {
    final response = await http.get(Uri.parse('http://192.168.1.6:8000/child'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        name = data['name'];
        password = data['password'];
        _nameController.text = name;
        _passwordController.text = password;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to fetch profile')));
    }
  }

  Future<void> updateProfile() async {
    final response = await http.put(
      Uri.parse('http://192.168.1.6:8000/child'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text,
        'password': _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [IconButton(icon: Icon(Icons.menu), onPressed: () {})],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildEditableField('Name', _nameController, Icons.edit),
            _buildEditableField(
              'Password',
              _passwordController,
              Icons.edit,
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProfile,
              child: Text('Update Profile'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool obscureText = false,
  }) {
    return ListTile(
      leading: Icon(
        label == 'Name' ? Icons.person_outline : Icons.lock_outline,
      ),
      title: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(labelText: label, border: InputBorder.none),
      ),
      trailing: IconButton(
        icon: Icon(icon),
        onPressed: () {
          setState(() {
            if (label == 'Name') name = controller.text;
            if (label == 'Password') password = controller.text;
          });
        },
      ),
    );
  }
}
