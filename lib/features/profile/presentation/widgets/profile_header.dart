// profile_header.dart
import 'package:flutter/material.dart';
import 'profile_widgets.dart';  // Import the reusable profile widgets

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  ProfileInfoItem(label: 'Posts', value: '25'),
                  SizedBox(width: 16),
                  ProfileInfoItem(label: 'Followers', value: '512'),
                  SizedBox(width: 16),
                  ProfileInfoItem(label: 'Following', value: '320'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
