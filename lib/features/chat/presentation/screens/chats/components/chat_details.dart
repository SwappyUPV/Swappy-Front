import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/components/exchange_notification.dart';
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
      fontWeight = FontWeight.w600; // Increase font weight by 2 levels
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: const TextStyle(
            color: Color(0xFF000000), // var(--Texto-Negro, #000)
            fontFamily: 'UrbaneMedium',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            height: 1.0, // line-height equivalent
            letterSpacing: -0.28,
          ),
        ),
        const SizedBox(height: 6),
        Opacity(
          opacity: 0.64,
          child: latestMessage?.type == ChatMessageType.exchangeNotification
              ? ExchangeNotification(
                  exchange: latestMessage,
                  isClickable: false,
                  receiver: latestMessage?.sender ?? "",
                )
              : Text(
                  latestMessage?.content ?? "Sin mensajes previos",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF707070), // var(--Texo---Mensaje, #707070)
                    fontFamily: 'OpenSans',
                    fontSize: 13,
                    fontStyle: FontStyle.normal,
                    fontWeight: fontWeight,
                    height: 1.0, // line-height equivalent
                  ),
                ),
        ),
      ],
    );
  }
}