// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pin/features/profile/presentation/widgets/post_grid.dart';  // Import the post grid widget
import 'package:pin/features/profile/presentation/widgets/profile_header.dart';  // Import the profile header widget
import 'settings_screen.dart';  // Import the settings screen

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2, color: Colors.black),
            onPressed: () {
              // Navigate to the settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const ProfileHeader(),  // Use the profile header widget
          const Divider(),
          const Expanded(child: PostGrid()),  // Use the post grid widget
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,  // Assuming this is the profile tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'Wardrobe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.message),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation based on index
        },
      ),
    );
  }
}
