import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import 'package:pin/features/auth/data/models/user_model.dart';

import '../../../../core/constants/constants.dart';

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

  Future<String> _getUserName(String? uid) async {
    if (uid == null || uid.isEmpty) {
      return 'Usuario desconocido'; // Devolver un valor por defecto si el UID es nulo o vacío
    }

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final userData = UserModel.fromFirestore(userDoc);
      return userData.name;
    }
    return 'Usuario desconocido'; // Valor por defecto si no se encuentra el usuario
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String currentUserUid = _auth.currentUser?.uid ?? '';

    return FutureBuilder<String>(
      future: _getUserName(
        exchange != null && exchange!.sender != currentUserUid
            ? exchange!
                .sender // Si el usuario actual no es el remitente, obtener el nombre del remitente
            : exchange
                ?.receiver, // Si es el remitente, obtener el nombre del receptor
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text("Error al cargar el nombre del usuario"));
        }

        final userName = snapshot.data ??
            'Usuario desconocido'; // Usar un valor predeterminado si es null
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
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: PrimaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.swap_horiz, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        messageText,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
