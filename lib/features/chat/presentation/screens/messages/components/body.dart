import 'package:flutter/material.dart';
import '../../../models/chat_message.dart';
import 'chat_input_field.dart';
import 'message.dart';
import '../../../../constants.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  final List<ChatMessage> messages = [];

  void _handleSendMessage(String messageText) {
    if (messageText.isNotEmpty) {
      final message = ChatMessage(
        messageType: ChatMessageType.text,
        messageContent: messageText,
        isSender: true,
        messageStatus: MessageStatus.viewed,
      );

      setState(() {
        messages.add(message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) =>
                  Message(message: messages[index]),
            ),
          ),
        ),
        ChatInputField(
          onMessageSent: (String messageText) {
            _handleSendMessage(messageText);
          },
        ),
      ],
    );
  }
}
