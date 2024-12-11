import 'package:flutter/material.dart';

class PhotoUploadSection extends StatelessWidget {
  const PhotoUploadSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Primero, añade una foto de la prenda que vas a vender o intercambiar. ¡Asegúrate de que aparezca nítida, de frente y bien iluminada!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        const SizedBox(height: 19),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.black),
          label: const Text(
            'Sube una foto',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}