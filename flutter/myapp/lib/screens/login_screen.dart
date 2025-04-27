import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'create_account_screen.dart';
import 'add_child_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Successful!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddChildProfileScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid email or password!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Sign-In Successful!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddChildProfileScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Sign-In Failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enter your email to reset password!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset email sent!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send reset email"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CreateAccountScreen()),
        );
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/background.png", fit: BoxFit.cover),
            ),
            Container(color: Colors.blue.withOpacity(0.4)),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔁 Replace LOGIN text with image
                    Image.asset("assets/welcome_to_educare.png", height: 80),
                    SizedBox(height: 25),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Please enter your email"
                                        : null,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: "Password",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            validator:
                                (value) =>
                                    value!.isEmpty
                                        ? "Please enter your password"
                                        : null,
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _resetPassword,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loginUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _signInWithGoogle,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Image.asset(
                                'assets/google_logo.png',
                                height: 24,
                              ),
                              label: Text(
                                "Continue with Google",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CreateAccountScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(color: Colors.white),
                                ),
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
      ),
    );
  }
}
