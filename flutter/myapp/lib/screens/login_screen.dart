// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'Learning and lesson/child_dashboard_screen.dart';
import 'create_account_screen.dart';
import 'add_child_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _childNameController =
      TextEditingController(); // 🔧 Controller for child name
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  bool isParent = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _toggleUserType(bool parentSelected) {
    if (isParent != parentSelected) {
      setState(() {
        isParent = parentSelected;
        if (_controller.isCompleted) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
      });
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email first.")),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset link sent to your email."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (isParent) {
          // 🔵 Parent login via Firebase
          await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Successful!"),
              backgroundColor: Colors.green,
            ),
          );

          // ✅ Redirect to AddChildProfileScreen for parent
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddChildProfileScreen(),
            ),
          );
        } else {
          // 🔴 Child login - verify with local DB using name
          bool childExists = await _verifyChildLoginLocally(
            _childNameController.text.trim(), // 🔧 Use name not email
            _passwordController.text.trim(),
          );

          if (childExists) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Child Login Successful!"),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LearningTabScreen()),
            );
          } else {
            throw Exception("Invalid child credentials");
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid email or password!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// ✅ NEW Updated function to also save child_id after successful login
  Future<bool> _verifyChildLoginLocally(String name, String password) async {
    final url = Uri.parse('http://192.168.1.6:8000/api/verify_child_login');
    // final url = Uri.parse('http://127.0.0.1:8000/api/verify_child_login');
    // final url = Uri.parse('http://100.64.32.53:8000/api/verify_child_login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// ✅ Check if login was successful
        if (data['success'] == true) {
          final childId = data['id'];

          /// 👈 Get child_id from backend response

          /// ✅ Save child_id in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('child_id', childId);

          debugPrint("Child ID saved: $childId");

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error verifying child login: $e');
      return false;
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Google Sign-In Successful!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddChildProfileScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Google Sign-In Failed!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _childNameController.dispose(); // 🔧 Dispose child name controller
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures layout resizes with keyboard
      backgroundColor: const Color(0xFF7BDAEB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to EduCare",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.person,
                        color: isParent ? Colors.blue : Colors.grey,
                        size: 32,
                      ),
                      onPressed: () => _toggleUserType(true),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Icon(
                        Icons.child_care,
                        color: !isParent ? Colors.black : Colors.grey,
                        size: 32,
                      ),
                      onPressed: () => _toggleUserType(false),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final isFront = _controller.value < 0.5;
                        final angle =
                            isFront
                                ? _controller.value * 3.14
                                : (1 - _controller.value) * 3.14;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(angle),
                          child: _buildLoginCard(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isParent
                  ? TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator:
                        (value) => value!.isEmpty ? 'Enter your email' : null,
                  )
                  : TextFormField(
                    controller: _childNameController,
                    decoration: const InputDecoration(labelText: 'Child Name'),
                    validator:
                        (value) => value!.isEmpty ? 'Enter child name' : null,
                  ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Enter your password' : null,
              ),
              const SizedBox(height: 10),

              // 🔵 Forgot password for parent only
              if (isParent)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resetPassword,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 75,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Login"),
              ),
              if (isParent) ...[
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text("Sign in with Google"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateAccountScreen(),
                        ),
                      ),
                  child: const Text("Don't have an account? Sign up"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
