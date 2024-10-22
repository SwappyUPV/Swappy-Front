// profile_widgets.dart
import 'package:flutter/material.dart';

// This widget is for profile stats like "Posts", "Followers", and "Following"
class ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoItem({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
