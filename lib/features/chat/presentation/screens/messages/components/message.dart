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
        mainAxisAlignment:
            isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: _messageContent(message, isSentByUser),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageContent(ChatMessageModel message, bool isSentByUser) {
    return Container(
      padding:
          const EdgeInsets.all(16), // Adjusted padding for the message bubble
      decoration: BoxDecoration(
        color: isSentByUser
            ? Color(0xFF1E1E1E)
            : Color(0xFFC2C2C2), // Change colors based on sender
        borderRadius: isSentByUser
            ? BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(12),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(45),
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: isSentByUser ? Colors.white : Colors.black,
          fontFamily: "OpenSans",
          fontSize: 16,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          height: 1.0, // line-height equivalent
        ),
      ),
    );
  }
}
