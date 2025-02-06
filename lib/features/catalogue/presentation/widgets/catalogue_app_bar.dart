import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class CatalogueAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/icons/logo.png',
            width: 10,
            height: 10,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.favorite_border, color: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pantalla de favoritos no implementada')),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
