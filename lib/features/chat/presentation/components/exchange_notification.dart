import 'package:flutter/material.dart';

class ExchangeNotification extends StatelessWidget {
  final String exchangeId;
  final VoidCallback onTap; // Callback para manejar el toque

  const ExchangeNotification({
    Key? key,
    required this.exchangeId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Llama al callback cuando se toca la notificación
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.swap_horiz, color: Colors.blueAccent),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "¡Tienes un nuevo intercambio! Toca para ver detalles.",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
