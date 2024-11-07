import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';

class ExchangeNotification extends StatelessWidget {
  final ChatMessageModel? exchange;

  ExchangeNotification({
    super.key,
    required this.exchange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Exchanges(
              selectedProduct: null,
              exchangeId: exchange?.id,
            ),
          ),
        );
      }, // Llama al callback cuando se toca la notificación
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
                "Me duele la cabeza arnau, haz tu el backend :c .",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
