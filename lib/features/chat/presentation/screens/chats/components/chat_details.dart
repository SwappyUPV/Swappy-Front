import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/components/exchange_notification.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';

class ChatDetails extends StatelessWidget {
  final String displayName;
  final ChatMessageModel? latestMessage;

  const ChatDetails({
    Key? key,
    required this.displayName,
    required this.latestMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Opacity(
          opacity: 0.64,
          child: latestMessage?.type == ChatMessageType.exchangeNotification
              ? ExchangeNotification(
            exchange: latestMessage,
            isClickable: false,
            receiver: latestMessage?.sender ?? "",
          )
              : Text(
            latestMessage?.content ?? "No messages",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
