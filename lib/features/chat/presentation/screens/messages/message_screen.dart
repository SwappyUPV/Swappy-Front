import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/services/chatService.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import '../../../constants.dart';
import 'components/body.dart';

class MessagesScreen extends StatelessWidget {
  final String chatId;

  const MessagesScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(chatId: chatId), // Pass chatId to the Body widget
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          const SizedBox(width: kDefaultPadding * 0.75),
          // The chat name and status can be dynamic based on chatId
          FutureBuilder<String>(
            future: _getChatName(chatId), // Fetch chat name based on chatId
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }
              if (!snapshot.hasData) {
                return const Text("Unknown Chat");
              }

              final chatName = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Text(
                    "Active 3m ago", // You may want to update this to be dynamic
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.swap_horiz),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Exchanges(
                  isNew: false,
                  selectedProduct: {},
                ),
              ),
            );
          },
        ),
        const SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }

  Future<String> _getChatName(String chatId) async {
    // Fetch the chat name based on chatId from your ChatService
    // Replace with your implementation
    final chatService = ChatService();
    final chat = await chatService.getChatById(chatId); // Create this method in ChatService
    return chat?.name ?? "Unknown Chat";
  }
}
