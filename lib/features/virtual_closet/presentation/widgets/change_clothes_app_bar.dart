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
        'ARMARIO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'UrbaneMedium',
          letterSpacing: -0.32,
        ),
      ),
      centerTitle: true,
      actions: [
        // Botón de filtros en la esquina superior derecha
        IconButton(
          icon: Icon(Icons.filter_alt, color: Colors.white),
          onPressed: () {
            // Muestra un mensaje de "No implementado" cuando se presione el botón
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Filtros"),
                content: Text("Esta función no ha sido implementada todavía."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);  // Cierra el diálogo
                    },
                    child: Text("Cerrar"),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}