import 'package:flutter/material.dart';
import 'package:pin/core/services/chat_service_2.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'chat_card.dart';

class Body extends StatelessWidget {
  final String searchQuery;
  final Function(String) onDeleteChat;

  const Body({
    Key? key,
    required this.searchQuery,
    required this.onDeleteChat,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Chat>>(
      stream: ChatService2().fetchChats(),
      builder: (context, snapshot) {
        //print("StreamBuilder snapshot: ${snapshot.connectionState}");
        if (!snapshot.hasData) {
          //print("No data in snapshot");
          return Center(child: CircularProgressIndicator());
        }
        final chats = snapshot.data!;
       //print("Number of chats: ${chats.length}");
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return Dismissible(
              key: Key(chat.uid),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                onDeleteChat(chat.uid);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: ChatCard(
                chat: chat,
                press: () {},
              ),
            );
          },
        );
      },
    );
  }
}