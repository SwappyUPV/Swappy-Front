import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import 'package:pin/features/auth/data/models/user_model.dart';

class ExchangeNotification extends StatelessWidget {
  final ChatMessageModel? exchange;
  final bool isClickable;
  final String receiver;

  ExchangeNotification({
    super.key,
    required this.exchange,
    required this.receiver,
    this.isClickable = true,
  });

  String _timeElapsed(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    }
  }

  Future<String> _getUserName(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userData = UserModel.fromFirestore(userDoc);
    return userData.name;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String currentUserUid = _auth.currentUser?.uid ?? '';

    return FutureBuilder<String>(
      future: (exchange != null && exchange!.sender != currentUserUid)
          ? _getUserName(exchange!.sender)
          : _getUserName(receiver),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error al cargar el nombre del usuario"),
          );
        }

        final userName = snapshot.data ?? 'Usuario';
        final String messageText = exchange != null
            ? (isClickable
                ? (exchange!.sender == currentUserUid
                    ? 'Enviaste a $userName una nueva oferta de intercambio'
                    : 'Has recibido una nueva oferta de intercambio de $userName')
                : (exchange!.sender == currentUserUid
                    ? 'Intercambio enviado'
                    : 'Intercambio recibido'))
            : '';

        return GestureDetector(
          onTap: isClickable
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Exchanges(
                        selectedProduct: null,
                        exchangeId: exchange?.id,
                      ),
                    ),
                  );
                }
              : null,
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.swap_horiz, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        messageText,
                        style: const TextStyle(color: Colors.blueAccent),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // Ensure text does not overflow
                      ),
                      if (exchange != null)
                        Text(
                          _timeElapsed(exchange!.timestamp),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
