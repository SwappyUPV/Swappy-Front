import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart'; // Use this Chat model
import 'package:pin/core/services/chat_service.dart';
import '../../../../constants.dart';
import '../../messages/message_screen.dart';
import 'chat_card.dart';

class Body extends StatefulWidget {
  final String searchQuery;
  const Body({super.key, required this.searchQuery});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ChatService _chatService = ChatService();

  Stream<List<Chat>> _getChatStream() {
    return _chatService.fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Chat>>(
        stream: _getChatStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay chats disponibles"));
          }

          final filteredChats = snapshot.data!
              .where((chat) => chat.name1
                  .toLowerCase()
                  .contains(widget.searchQuery.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: filteredChats.length,
            itemBuilder: (context, index) => ChatCard(
              chat: filteredChats[index],
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MessagesScreen(chat: filteredChats[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}