import 'package:flutter/material.dart';
import 'package:pin/features/virtual_closet/presentation/screens/change_clothes_screen.dart';

class MyGarmentsButton extends StatelessWidget {
  final VoidCallback onPressed; // Agregamos la propiedad onPressed

  const MyGarmentsButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: GestureDetector(
        onTap: onPressed, // Usamos el callback que nos pasó VirtualClosetScreen
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            'Mi armario',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Open Sans',
            ),
          ),
        ),
      ),
    );
  }
}
