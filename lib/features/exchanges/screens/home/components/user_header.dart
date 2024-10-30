import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final String nombreUsuario;
  final String fotoUrl;
  final bool esMio;

  const UserHeader({
    super.key,
    required this.nombreUsuario,
    required this.fotoUrl,
    required this.esMio,
  });

  @override
  Widget build(BuildContext context) {
    // Ajustar el tamaño de la imagen según el ancho de la pantalla y si es web o móvil
    final double imageSize = kIsWeb
        ? MediaQuery.of(context).size.width * 0.06 // Tamaño de imagen en web
        : MediaQuery.of(context).size.width * 0.2; // Tamaño de imagen en móvil

    final double maxWidth = 1000.0; // Máximo ancho del header en web

    return Container(
      // Aplicar margen solo si es web
      margin: kIsWeb
          ? const EdgeInsets.only(bottom: 30, top: 20, left: 20)
          : EdgeInsets.zero,
      padding: const EdgeInsets.all(8.0),
      width: maxWidth,
      alignment: Alignment.centerLeft, // Alinear todo el header a la izquierda
      child: Row(
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            child: Hero(
              tag: "userImage_$nombreUsuario",
              child: Image.asset(
                fotoUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreUsuario,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  esMio
                      ? "Estos son los items que perderás de tu armario al realizar este intercambio"
                      : "Estos son los items que obtendrás de $nombreUsuario al realizar este intercambio",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
