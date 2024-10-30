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
              stream: _chatService.fetchMessages(widget.chatId), // Fetch messages for the chatId
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true, // Show the latest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) => Message(message: messages[index]), // Use the widget
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
     final user = await UserService().fetchAuthenticatedUserID();

      if (user != null) {
        String senderId = user; // Get the UID from the UserModel
        await _chatService.sendMessage(widget.chatId, messageText, senderId);
      } else {
        print("User is not authenticated.");
      }
    }
  }

}
