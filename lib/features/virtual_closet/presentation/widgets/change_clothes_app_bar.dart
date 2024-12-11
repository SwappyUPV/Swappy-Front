import 'package:flutter/material.dart';

class ChangeClothesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onIconPressed;

  const ChangeClothesAppBar({
    Key? key,
    required this.onIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onIconPressed,
      ),
      title: const Text(
        'MI ARMARIO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'UrbaneMedium',
          letterSpacing: -0.32,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}