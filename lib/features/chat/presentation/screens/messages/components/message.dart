import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import '../../../../constants.dart';

class Messages extends StatefulWidget {
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
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String? selectedEmoji;

  @override
  Widget build(BuildContext context) {
    bool isSentByUser = widget.message.sender == widget.userId;
    String formattedTime = DateFormat('hh:mm a').format(widget.message.timestamp);

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Column(
        crossAxisAlignment:
        isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75, // 3/4 of the screen width
                  ),
                  child: Stack(
                    children: [
                      _messageContent(widget.message, isSentByUser),
                      if (!isSentByUser)
                        Positioned(
                          bottom: 0,
                          right: 0, // Adjust this value to position the emoji closer to the bubble
                          child: _reactionWrapper(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8),
            child: Text(
              formattedTime,
              style: const TextStyle(
                color: Color(0xFF939090), // var(--Hora-Fecha-Mensaje, #939090)
                fontFamily: "OpenSans",
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                height: 1.0, // line-height equivalent
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reactionWrapper() {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          if (selectedEmoji != null) {
            selectedEmoji = null; // Remove the selected emoji
          } else {
            _showEmojiPicker(); // Show emoji picker if no emoji is selected
          }
        });
      },
      child: selectedEmoji == null
          ? const Padding(
        padding: EdgeInsets.all(0), // No padding
        child: Icon(
          Icons.emoji_emotions_outlined,
          size: 20.0, // Smaller icon size
          color: Colors.grey,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(0), // No padding
        child: Text(
          selectedEmoji!,
          style: GoogleFonts.notoColorEmoji(fontSize: 15.0),
        ),
      ),
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmoji = emojis[index];
                  });
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    emojis[index],
                    style: GoogleFonts.notoColorEmoji(fontSize: 24.0),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _messageContent(ChatMessageModel message, bool isSentByUser) {
    return Container(
      padding: const EdgeInsets.all(16), // Adjusted padding for the message bubble
      decoration: BoxDecoration(
        color: isSentByUser
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFC2C2C2), // Change colors based on sender
        borderRadius: isSentByUser
            ? const BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(12),
        )
            : const BorderRadius.only(
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

// Replace this with your actual emojis
const List<String> emojis = [
  "😀", "😂", "😍", "🥺", "😎", "👍", "🙏", "🔥", "❤️", "🥳",
  "😢", "😡", "😱", "🤔", "🤗", "😇", "😜", "😴", "🤐", "🤓",
  "😷", "🤒", "🤕", "🤢", "🤮", "🤧", "😈", "👿", "👻", "💀",
  "👽", "🤖", "💩", "😺", "😸", "😹", "😻", "😼", "😽", "🙀",
  "😿", "😾", "🙈", "🙉", "🙊", "💋", "💌", "💘", "💝", "💖",
  "💗", "💓", "💞", "💕", "💟", "❣️", "💔", "❤️‍🔥", "❤️‍🩹", "❤",
];