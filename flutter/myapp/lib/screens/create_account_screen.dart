import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _createAccount() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'childProfileCompleted': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("✅ User Created: ${user.email}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Account Created! Please log in."),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Sign-up Failed";

      if (e.code == 'email-already-in-use') {
        errorMessage = "Email already in use, try a new email";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password is too weak";
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up Failed: ${e.toString()}"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.blue.withOpacity(0.5)),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 Replaced text with image
                  Image.asset(
                    "assets/images/create_acc.png", // Make sure this image exists
                    height: 80,
                  ),
                  SizedBox(height: 25),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // 🔹 Email Field
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              EmailValidator.validate(value!) ? null : "Enter a valid email",
                        ),
                        SizedBox(height: 15),

                        // 🔹 Password Field
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscureText = !_obscureText),
                            ),
                          ),
                          validator: (value) {
                            if (value!.length < 8) return "Password must be at least 8 characters";
                            if (!RegExp(r'[0-9]').hasMatch(value)) return "Include at least one number";
                            if (!RegExp(r'[!@#$%^&*(),.?\":{}|<>]').hasMatch(value)) return "Include at least one special character";
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // 🔹 Create Account Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _createAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text("Create Account", style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                        SizedBox(height: 20),

                        // 🔹 Navigate to Login Screen
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?", style: TextStyle(color: Colors.white)),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              ),
                              child: Text("Login"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
