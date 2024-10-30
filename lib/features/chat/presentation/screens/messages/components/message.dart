import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import '../../../../constants.dart';

class Message extends StatelessWidget {
  final ChatMessageModel message;

  const Message({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    Widget messageContent(ChatMessageModel message) {
      switch (message.type) {
        case ChatMessageType.text:
          return Text(message.content);
      // Handle other message types (image, audio, video) as needed
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment: message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
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
            const Icon(Icons.done, color: kPrimaryColor), // Icono de mensaje enviado
          ],
        ],
      ),
    );
  }
}
