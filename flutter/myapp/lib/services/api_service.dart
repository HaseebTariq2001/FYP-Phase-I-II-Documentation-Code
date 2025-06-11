import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://educare-backend-9nb1.onrender.com";
  // static const String baseUrl = "http://100.64.64.88:8000";

  static Future<Map<String, dynamic>> assessAutism(List<double> scores) async {
    final response = await http.post(
      Uri.parse("$baseUrl/assess_autism"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "scores": scores.map((score) => score.toInt()).toList(),
      }), // Convert doubles to int
    );

    return jsonDecode(response.body);
  }
}
