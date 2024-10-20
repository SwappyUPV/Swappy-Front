import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

Widget buildChatBubble(
  Widget child, {
  required types.Message message,
  required types.User currentUser,
  required bool nextMessageInGroup,
}) {
  return Row(
    mainAxisAlignment: currentUser.id != message.author.id
        ? MainAxisAlignment.start
        : MainAxisAlignment.end,
    children: [
      // Mostrar el avatar del usuario si el mensaje no es del usuario actual
      if (currentUser.id != message.author.id)
        CircleAvatar(
          backgroundImage: message.author.imageUrl != null &&
                  message.author.imageUrl!.isNotEmpty
              ? NetworkImage(message.author.imageUrl!)
              : null, // Si no hay imagen, usar avatar por defecto
          radius: 16,
          child: message.author.imageUrl == null ||
                  message.author.imageUrl!.isEmpty
              ? Icon(Icons.person, size: 16)
              : null, // Si no hay imagen, mostrar un ícono
        ),

      const SizedBox(width: 8),

      // Burbujas de mensajes
      Bubble(
        color: currentUser.id != message.author.id ||
                message.type == types.MessageType.image
            ? const Color(
                0xfff5f5f7) // Color para mensajes de otros usuarios o mensajes de imagen
            : const Color(0xff6f61e8), // Color para mensajes del usuario actual
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 6)
            : null,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : currentUser.id != message.author.id
                ? BubbleNip.leftBottom
                : BubbleNip
                    .rightBottom, // Ubicación del "triángulo" de la burbuja
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentUser.id != message.author.id)
              Text(
                message.author.firstName ??
                    'Unknown', // Mostrar el nombre del autor
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            child, // Contenido del mensaje
          ],
        ),
      ),
    ],
  );
}
