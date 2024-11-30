import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:pin/features/wishlist/presentation/screens/wishlist_screen.dart';
import 'package:pin/features/wishlist/services/wishlist_service.dart';

class CatalogueAppBar extends StatelessWidget implements PreferredSizeWidget {
  final WishlistService _wishlistService = WishlistService();

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
          icon: const Icon(Icons.favorite_border, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WishlistScreen(
                  wishlistItems: _wishlistService.wishlistItems,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
