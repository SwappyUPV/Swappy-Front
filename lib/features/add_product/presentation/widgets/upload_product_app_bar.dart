import 'package:flutter/material.dart';

class UploadProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UploadProductAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.black,
      alignment: Alignment.center,
      child: const Text(
        'SUBE UNA PRENDA',
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