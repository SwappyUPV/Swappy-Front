import 'package:flutter/material.dart';

class UploadProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isModifyMode; // Booleano que controla el título y el botón
  final VoidCallback? onIconPressed;

  // Constructor modificado para aceptar el parámetro booleano
  const UploadProductAppBar({
    Key? key,
    this.onIconPressed,
    this.isModifyMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: isModifyMode 
        ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onIconPressed,
          )
        : null, // Si no es modifyMode, no muestra el icono
      title: Text(
        isModifyMode ? 'MODIFICAR' : 'SUBE UNA PRENDA',
        style: const TextStyle(
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
  Size get preferredSize => const Size.fromHeight(56); // Tamaño del AppBar
}
