import 'package:flutter/material.dart';
import 'package:pin/features/virtual_closet/presentation/widgets/Advice.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Muestra un aviso en el centro de la pantalla
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Advice(),
              actions: [
              ],
            );
          },
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.75),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '?',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFA6A6A6),
            ),
          ),
        ),
      ),
    );
  }
}