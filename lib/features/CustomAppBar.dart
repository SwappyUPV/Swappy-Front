import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String iconPath;
  final VoidCallback onIconPressed;
  final IconPosition iconPosition;

  // Constructor
  CustomAppBar({
    required this.title,
    required this.iconPath,
    required this.onIconPressed,
    this.iconPosition = IconPosition.right, // Default to right
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          const Color.fromARGB(255, 0, 0, 0), // Customize this color as needed
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'UrbaneMedium',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      leading: iconPosition == IconPosition.left
          ? Padding(
              padding: const EdgeInsets.only(left: 17),
              child: IconButton(
                icon: SvgPicture.asset(
                  iconPath,
                  height: 24,
                  width: 24,
                  color: Colors.white,
                ),
                onPressed: onIconPressed,
              ),
            )
          : null,
      actions: iconPosition == IconPosition.right
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 17),
                child: IconButton(
                  icon: SvgPicture.asset(
                    iconPath,
                    height: 24,
                    width: 24,
                    color: Colors.white,
                  ),
                  onPressed: onIconPressed,
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Enum to handle icon position
enum IconPosition { left, right }
