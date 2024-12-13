import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'package:pin/features/chat/presentation/components/exchange_notification.dart';
import 'package:pin/core/services/chat_service_2.dart';
import '../../../../constants.dart';
import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatefulWidget {
  final Chat chat;
  final String? userId; // userId passed as parameter

  const Body({super.key, required this.chat, required this.userId});

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  final ChatService2 _chatService = ChatService2();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: StreamBuilder<List<ChatMessageModel>>(
              stream: _chatService.fetchMessages(widget.chat.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error cargando mensajes"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Sin mensajes todavía"));
                }

                final messages = snapshot.data!.reversed.toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    if (message.type == ChatMessageType.exchangeNotification) {
                      return ExchangeNotification(
                        exchange: message,
                        receiver: widget.chat.user1 == widget.userId
                            ? widget.chat.user2
                            : widget.chat.user1,
                      );
                    }
                    return Messages(
                      message: message,
                      userId: widget.userId, // Use widget.userId directly
                      user1: widget.chat.user1,
                      user2: widget.chat.user2,
                      userImage1: widget.chat.image1,
                      userImage2: widget.chat.image2,
                    );
                  },
                );
              },
            ),
          ),
        ),
        ChatInputField(
          onMessageSent: (String messageText) async {
            if (messageText.isNotEmpty && widget.userId != null) {
              // Use widget.userId here
              await _chatService.sendMessage(
                  widget.chat.uid, messageText, widget.userId!);
            } else {
              print(
                  "Mensaje no enviado, campo vacío o usuario no loggeado.");
            }
          },

        ),
      ],
    );
  }
}
