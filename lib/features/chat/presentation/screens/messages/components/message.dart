import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import '../../../../constants.dart';

class Messages extends StatelessWidget {
  final ChatMessageModel message;
  final String? userId; // This is the ID of the logged-in user
  final String user1;
  final String user2;
  final String userImage1;
  final String userImage2;

  const Messages({
    super.key,
    required this.message,
    this.userId,
    required this.user1,
    required this.user2,
    required this.userImage1,
    required this.userImage2,
  });

  @override
  Widget build(BuildContext context) {
    bool isSentByUser = message.sender == userId;

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment: isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Show the other user's avatar if the message is not sent by the logged-in user
          if (!isSentByUser)
            CircleAvatar(
              radius: 20, // Increased size for the avatar
              backgroundImage: message.sender == user1
                  ? _getImageProvider(userImage1)
                  : _getImageProvider(userImage2), // Use userImage1 or userImage2 based on the sender
            ),
          const SizedBox(width: kDefaultPadding / 2),
          // Display message content
          _messageContent(message, isSentByUser),
          // Show the logged-in user's avatar if the message is sent by the logged-in user
          if (isSentByUser) ...[
            const SizedBox(width: kDefaultPadding / 2),
            CircleAvatar(
              radius: 20, // Increased size for the avatar
              backgroundImage: message.sender == user1
                  ? _getImageProvider(userImage1)
                  : _getImageProvider(userImage2), // Use userImage1 or userImage2 based on the sender
            ),
          ],
        ],
      ),
    );
  }

  Widget _messageContent(ChatMessageModel message, bool isSentByUser) {
    return Container(
      padding: const EdgeInsets.all(12), // Increased padding for the message bubble
      decoration: BoxDecoration(
        color: isSentByUser ? Colors.blueAccent : Colors.grey[300], // Change colors based on sender
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message.content,
        style: TextStyle(fontSize: 16, color: isSentByUser ? Colors.white : Colors.black), // Increased font size
      ),
    );
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.isNotEmpty) {
      return AssetImage(imagePath);
    }
    return const AssetImage("assets/images/user.png");
  }
}
