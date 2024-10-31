import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart'; // Use this Chat model
import 'package:pin/features/chat/presentation/screens/chats/services/chatService.dart';
import '../../../components/filled_outline_button.dart';
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
  bool showActive = false;
  bool showRecent = true; // Start with recent chats selected by default
  final ChatService _chatService = ChatService();

  Stream<List<Chat>> _getChatStream() {
    if (showRecent) {
      return _chatService.fetchChats(showRecent: true);
    } else if (showActive) {
      return _chatService.fetchChats(showActive: true);
    } else {
      // Default to an empty stream if neither flag is set (should not happen)
      return Stream.value([]);
    }
  }

  void _toggleChats(bool recent) {
    setState(() {
      showRecent = recent;
      showActive = !recent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlineButton(
                press: () => _toggleChats(true), // Set to recent chats
                text: "Recent Message",
                isFilled: showRecent,
              ),
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () => _toggleChats(false), // Set to active chats
                text: "Active",
                isFilled: showActive,
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Chat>>(
            stream: _getChatStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No chats found"));
              }

              final filteredChats = snapshot.data!
                  .where((chat) => chat.name1.toLowerCase().contains(widget.searchQuery.toLowerCase()))
                  .toList();

              return ListView.builder(
                itemCount: filteredChats.length,
                itemBuilder: (context, index) => ChatCard(
                  chat: filteredChats[index],
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagesScreen(chat: filteredChats[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
