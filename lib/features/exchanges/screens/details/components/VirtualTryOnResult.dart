import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'virtual_try_on_result_app_bar.dart';
class VirtualTryOnResultScreen extends StatelessWidget {
  final Uint8List tryOnImage;

  const VirtualTryOnResultScreen({Key? key, required this.tryOnImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: VirtualTryOnResultAppBar(
        onIconPressed: () {
            Navigator.of(context).pop(); // Si fromExchange es true, hace un pop
        },

      ),
      body: Center(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5), // Fondo oscuro si es necesario
          ),
          child: Image.memory(
            tryOnImage,
            fit: BoxFit.cover, // La imagen cubre toda la pantalla
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}