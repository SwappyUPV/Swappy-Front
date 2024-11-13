import 'dart:async'; // Asegúrate de importar dart:async para usar Timer
import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/chats_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  final String title, description, image;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    // Iniciar un temporizador para regresar a ChatsScreen después de 3 segundos
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              ChatsScreen(), // Asegúrate de que ChatsScreen esté disponible
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Centrar todo el contenido en la pantalla
        child: SingleChildScrollView(
          // Permitir desplazamiento en caso de que el contenido sea demasiado largo
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Espaciado horizontal
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Dejar que la columna ocupe solo el espacio necesario
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.image,
                  height: 250,
                  fit: BoxFit
                      .contain, // Ajustar la imagen dentro del espacio disponible
                ),
                const SizedBox(
                    height: 20), // Espacio entre la imagen y el texto
                OnbordTitleDescription(
                  title: widget.title,
                  description: widget.description,
                ),
                const SizedBox(height: 20), // Espacio inferior
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnbordTitleDescription extends StatelessWidget {
  const OnbordTitleDescription({
    super.key,
    required this.title,
    required this.description,
  });

  final String title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w100),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
