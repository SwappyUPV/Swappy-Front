import 'package:flutter/material.dart';
import '../../../../constants.dart';

class ProfileImage extends StatelessWidget {
  final String profileImage;

  const ProfileImage({
    Key? key,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 32.5,
      backgroundImage: profileImage.startsWith('assets')
          ? AssetImage(profileImage) as ImageProvider
          : NetworkImage(profileImage),
    );
  }
}