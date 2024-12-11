import 'package:flutter/material.dart';

class VirtualClosetAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VirtualClosetAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.black,
      alignment: Alignment.center,
      child: const Text(
        'MIS PRENDAS',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'UrbaneMedium',
          letterSpacing: -0.32,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}