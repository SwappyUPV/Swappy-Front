import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';

class ChatDetails extends StatelessWidget {
  final String displayName;
  final ChatMessageModel? latestMessage;
  final int unreadMessagesCount;

  const ChatDetails({
    super.key,
    required this.displayName,
    required this.latestMessage,
    required this.unreadMessagesCount,
  });

  @override
  Widget build(BuildContext context) {
    FontWeight fontWeight = FontWeight.w400;
    if (unreadMessagesCount > 0) {
      fontWeight = FontWeight.w600;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: const TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'UrbaneMedium',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            height: 1.0,
            letterSpacing: -0.28,
          ),
        ),
        const SizedBox(height: 6),
        Opacity(
          opacity: 0.64,
          child: Builder(
            builder: (context) {
              if (latestMessage?.type == ChatMessageType.exchangeNotification) {
                final currentUser = FirebaseAuth.instance.currentUser;
                final isCurrentUserSender =
                    latestMessage?.sender == currentUser?.uid;
                return Text(
                  isCurrentUserSender ? "Oferta enviada" : "Oferta recibida",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF707070),
                    fontFamily: 'OpenSans',
                    fontSize: 13,
                    fontStyle: FontStyle.normal,
                    fontWeight: fontWeight,
                    height: 1.0,
                  ),
                );
              }
              return Text(
                latestMessage?.content ?? "Sin mensajes previos",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF707070),
                  fontFamily: 'OpenSans',
                  fontSize: 13,
                  fontStyle: FontStyle.normal,
                  fontWeight: fontWeight,
                  height: 1.0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
