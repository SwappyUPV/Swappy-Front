import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/chats/services/chatService.dart'; // Import your ChatService
import 'package:intl/intl.dart'; // For date formatting
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import '../../../../constants.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.chat,
    required this.press,
  });

  final Chat chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService(); // Initialize your ChatService

    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(chat.image),
                ),
                if (chat.isActive)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<ChatMessageModel?>(
                      future: chatService.getLatestMessage(chat.uid), // Fetch the latest message for this chat
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Opacity(
                            opacity: 0.64,
                            child: Text("Loading...", // Show loading text while fetching
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Opacity(
                            opacity: 0.64,
                            child: Text(
                              "No messages",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }

                        final latestMessage = snapshot.data!;
                        return Opacity(
                          opacity: 0.64,
                          child: Text(
                            latestMessage.content, // Display the message text
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: FutureBuilder<ChatMessageModel?>(
                future: chatService.getLatestMessage(chat.uid), // Fetch the latest message again for the timestamp
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("...");
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Text(""); // Return empty if no message found
                  }

                  final latestMessage = snapshot.data!;
                  return Text(DateFormat.jm().format(latestMessage.timestamp)); // Format and display the timestamp
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
