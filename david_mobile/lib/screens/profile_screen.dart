import 'package:flutter/material.dart';
import 'package:labact2/services/user_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final data = await _userService.getUserData();
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Cover Photo
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.blue[300],
                    child: const Center(
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),

                  // Profile Picture
                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Name
                  Text(
                    "${userData?['firstName']} ${userData?['lastName']}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    userData?['email'] ?? "Email not available",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),

                  // Account Type
                  Text(
                    "Account Type: ${userData?['type'] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
