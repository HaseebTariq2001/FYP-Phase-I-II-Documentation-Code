import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
      "http://127.0.0.1:5000"; // Update with your Flask server URL

  static Future<String?> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 201) {
      return "User created successfully!";
    } else {
      return jsonDecode(response.body)["error"] ?? "Signup failed";
    }
  }

  static Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["access_token"];
    } else {
      return null;
    }
  }
}
