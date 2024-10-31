import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/chats/services/chatService.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import '../../../constants.dart';
import 'components/body.dart';
import 'package:intl/intl.dart';

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
          FutureBuilder<Chat?>(
            future: _getChat(chatId), // Fetch chat data based on chatId
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/images/user.png"), // Placeholder image
                );
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const CircleAvatar(
                  backgroundImage: AssetImage(
                      "assets/images/user_2.png"), // Placeholder image
                );
              }

              final chat = snapshot.data!;
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        chat.image),
                  ),
                  const SizedBox(width: kDefaultPadding * 0.75),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        chat.isActive
                            ? "Active Now"
                            : "Last active ${_formatTimestamp(chat.timestamp)}", // Use formatted timestamp
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
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
                  selectedProduct: null,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }

  //HELPER METHODS
  Future<Chat?> _getChat(String chatId) async {
    // Fetch the chat details based on chatId from ChatService
    final chatService = ChatService();
    return await chatService.getChatById(chatId); // Fetch chat data
  }

  String _formatTimestamp(DateTime timestamp) {
    // Format the timestamp to a readable string
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy')
          .format(timestamp); // E.g., "Oct 30, 2024"
    }
  }
}
