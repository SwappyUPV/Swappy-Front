import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({Key? key}) : super(key: key);

  // Función para mostrar el popup "Outfit guardado en la galería"
  void _showOutfitSavedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Outfit guardado'),
        content: Text('El outfit ha sido guardado en tu galería.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: GestureDetector(
        onTap: () => _showOutfitSavedDialog(context), // Mostrar el popup al hacer clic
        child: Icon(
          Icons.add_a_photo,
          size: 24,
          color: Colors.black,
        ),
      ),
    );
  }
}