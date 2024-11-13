import 'package:flutter/material.dart';
import 'package:pin/features/auth/data/models/user_model.dart'; // Import UserModel

class ProfileHeader extends StatelessWidget {
  final UserModel userModel;

  const ProfileHeader({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0), // Add left margin
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
        children: [
          CircleAvatar(
            backgroundImage: userModel.profilePicture != null
                ? AssetImage(userModel.profilePicture!)
                : null,
            radius: 50,
          ),
          const SizedBox(height: 8),
          Text(
            userModel.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(userModel.email),
          // Add more user information here as needed
        ],
      ),
    );
  }
}
