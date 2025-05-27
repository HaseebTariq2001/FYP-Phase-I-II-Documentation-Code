// ignore_for_file: unused_element_parameter
// Specific child updation is working perfectly

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/screens/child_profile_management_list.dart';
import 'dart:convert';
import 'dart:typed_data';
// import 'home_screen.dart';
import 'package:image_picker/image_picker.dart';

class ChildProfileScreen extends StatefulWidget {
  // Added: Accept childName as a parameter
  final String childName;

  ChildProfileScreen({required this.childName});

  @override
  _ChildProfileScreenState createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  late String name = '';
  late String password = '';
  Uint8List? imageData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    fetchChildData();
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        imageData = bytes;
      });
    }
  }

  Future<void> fetchChildData() async {
    // Modified: Fetch specific child data using the childName parameter
    final response = await http.get(
      Uri.parse('http://192.168.1.10:8000/child/${widget.childName}'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        name = data['name'];
        password = data['password'];
        _nameController.text = name;
        _passwordController.text = password;
        if (data['image_blob'] != null) {
          print('Image Blob received: ${data['image_blob'].substring(0, 30)}');
          imageData = base64Decode(data['image_blob']);
        }
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to fetch profile')));
    }
  }

  Future<void> updateProfile() async {
    String? base64Image = imageData != null ? base64Encode(imageData!) : null;

    // Modified: Update specific child using the childName
    final response = await http.put(
      Uri.parse('http://192.168.1.10:8000/child/${widget.childName}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text,
        'password': _passwordController.text,
        'image_blob': base64Image,
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
        title: Text(
          "Child Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SelectChildScreen()),
            );
          },
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // added for icon
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      imageData != null ? MemoryImage(imageData!) : null,
                  backgroundColor: Colors.grey[300],
                  child:
                      imageData == null ? Icon(Icons.person, size: 60) : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: InkWell(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildEditableField(
              'Child Name',
              _nameController,
              Icons.person_outline,
            ),
            _buildEditableFieldWithEye(
              'Password',
              _passwordController,
              Icons.lock_outline,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildEditableFieldWithEye(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
