import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Macbook's IP addy (make sure your phone/simulator can reach this IP)
const String host = 'http:192.168.76.46:8000'; //'http://192.168.1.3:8000';

class UserService {
  Map<String, dynamic> data = {};

  /// **Login User**
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    // Normalize email
    email = email.trim().toLowerCase();

    final response = await http.post(
      Uri.parse('$host/api/users/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);

      // Save user data locally after successful login
      await saveUserData(data);

      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  /// **Save User Data to SharedPreferences**
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    print("Saving user data: $userData"); // 👈 Debug log

    await prefs.setString('firstName', userData['firstName'] ?? '');
    await prefs.setString('lastName', userData['lastName'] ?? '');
    await prefs.setString('email', userData['email'] ?? '');
    await prefs.setString('token', userData['token'] ?? '');
    await prefs.setString('type', userData['type'] ?? '');
  }

  /// **Retrieve User Data from SharedPreferences**
  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString('firstName') ?? '',
      'lastName': prefs.getString('lastName') ?? '',
      'email': prefs.getString('email') ?? '',
      'token': prefs.getString('token') ?? '',
      'type': prefs.getString('type') ?? '',
    };
  }

  /// **Check if User is Logged in**
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  /// **Logout and Clear User Data**
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
