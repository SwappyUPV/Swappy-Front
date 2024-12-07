import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin/core/constants/constants.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onIconPressed;

  ChatAppBar({required this.onIconPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PrimaryColor,
      automaticallyImplyLeading: false,
      title: const Center(
        child: Text(
          'MENSAJES',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontFamily: 'UrbaneMedium',
            fontSize: 16,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.32,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: IconButton(
            icon: SvgPicture.asset(
              'icons/new_chat.svg',
              height: 24,
              width: 24,
              color: Colors.white, // Set the icon color to white
            ),
            onPressed: onIconPressed,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}