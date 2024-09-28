import 'package:flutter/material.dart';

import '../../Services/authentication.dart';
import '../Welcome/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout user
              AuthMethod().signOut();
              // Navigate to LoginScreen on logout
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false, // This removes all previous routes
              );
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('Welcome to Home Screen!'),
      ),
    );
  }
}
