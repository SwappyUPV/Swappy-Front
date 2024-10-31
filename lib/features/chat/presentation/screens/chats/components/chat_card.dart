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
  String _displayName = "";
  String _profileImage = ""; // Initially empty

  @override
  void initState() {
    super.initState();
    _fetchLatestMessage();
  }

  Future<void> _fetchLatestMessage() async {
    final message = await chatService.getLatestMessage(widget.chat.uid);

    // Fetch current user ID
    final userId = await chatService.getUserId();

    // Determine the other user in the chat and set the name and image dynamically
    if (userId != null) {
      if (widget.chat.user1 == userId) {
        setState(() {
          _displayName = widget.chat.name2;
          _profileImage = widget.chat.image2.isNotEmpty
              ? widget.chat.image2
              : 'assets/images/user.png';
        });
      } else {
        setState(() {
          _displayName = widget.chat.name1;
          _profileImage = widget.chat.image1.isNotEmpty
              ? widget.chat.image1
              : 'assets/images/user.png';
        });
      }
    } else {
      setState(() {
        _displayName = widget.chat.name1; // fallback to default
        _profileImage = widget.chat.image1.isNotEmpty
            ? widget.chat.image1
            : 'assets/images/user.png'; // fallback image
      });
    }

    setState(() {
      latestMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while fetching data
    if (_profileImage.isEmpty || _displayName.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey, // Placeholder color
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 100, // Placeholder width
                      color: Colors.grey, // Placeholder color
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 150, // Placeholder width
                      color: Colors.grey, // Placeholder color
                    ),
                  ],
                ),
              ),
            ),
            const Opacity(
              opacity: 0.64,
              child: Text("..."), // Placeholder for timestamp
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessagesScreen(chat: widget.chat), // Pass the entire Chat object
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
                  backgroundImage: AssetImage(_profileImage),
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
                      _displayName,
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
