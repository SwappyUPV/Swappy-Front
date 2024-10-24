import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../models/chat_message.dart';

class Message extends StatelessWidget {
  final ChatMessage message;

  const Message({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    Widget messageContent(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return Text(message.messageContent);
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender)
            const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage("assets/images/user_2.png"),
            ),
          const SizedBox(width: kDefaultPadding / 2),
          messageContent(message),
          if (message.isSender) ...[
            const SizedBox(width: kDefaultPadding / 2),
            const Icon(Icons.done,
                color: kPrimaryColor), // Icono de mensaje enviado
          ],
        ],
      ),
    );
  }
}
