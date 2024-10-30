import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/chats/services/chatService.dart'; // Import your ChatService
import 'package:intl/intl.dart'; // For date formatting
import 'package:pin/features/chat/presentation/screens/messages/message_screen.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import '../../../../constants.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({
    super.key,
    required this.chat,
    required this.press,
  });

  final Chat chat;
  final VoidCallback press;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final ChatService chatService = ChatService();
  ChatMessageModel? latestMessage;

  @override
  void initState() {
    super.initState();
    _fetchLatestMessage();
  }

  Future<void> _fetchLatestMessage() async {
    final message = await chatService.getLatestMessage(widget.chat.uid);
    setState(() {
      latestMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessagesScreen(chatId: widget.chat.uid),
        ));
        _fetchLatestMessage(); // Refresh when returning
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(widget.chat.image),
                ),
                if (widget.chat.isActive)
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
                      widget.chat.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        latestMessage?.content ?? "No messages",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(
                latestMessage != null
                    ? DateFormat.jm().format(latestMessage!.timestamp)
                    : "",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
