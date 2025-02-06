import 'package:flutter/material.dart';

class Advice extends StatelessWidget {
  const Advice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Desliza cada prenda para probar combinaciones.',
        textAlign: TextAlign.center, // Centra el texto horizontalmente
        style: TextStyle(
          color: Color(0xFF8B7B7B),
          fontSize: 18,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
