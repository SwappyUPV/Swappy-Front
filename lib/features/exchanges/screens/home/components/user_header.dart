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
    return Container(
      padding: const EdgeInsets.all(11.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      width: double.infinity,
      child: Row(
        children: [
          // Imagen del usuario (30% del ancho)
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.2,
            child: Hero(
              tag: "userImage_$nombreUsuario",
              child: Image.asset(
                fotoUrl, // Asegúrate de que esto sea la ruta de la foto de usuario
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16), // Espacio entre imagen y texto
          // Información del usuario (70% del ancho)
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
