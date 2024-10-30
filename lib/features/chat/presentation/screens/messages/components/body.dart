import 'package:flutter/material.dart';
import 'package:pin/core/services/user_service.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart'; // Update import
import 'package:pin/features/chat/presentation/screens/chats/services/chatService.dart';
import '../../../../constants.dart';
import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatefulWidget {
  final String chatId;

  const Body({super.key, required this.chatId});

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: StreamBuilder<List<ChatMessageModel>>(
              stream: _chatService.fetchMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!;
                print(messages);
                // Reverse the messages list to display them in order
                final orderedMessages = List.from(messages.reversed);

                return ListView.builder(
                  itemCount: orderedMessages.length,
                  itemBuilder: (context, index) => Message(message: orderedMessages[index]),
                );
              },
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

  Future<void> _handleSendMessage(String messageText) async {
    if (messageText.isNotEmpty) {
      final userId = await UserService().fetchAuthenticatedUserID();
      if (userId != null) {
        await _chatService.sendMessage(widget.chatId, messageText, userId);
      } else {
        print("User is not authenticated.");
      }
    }
  }
}
