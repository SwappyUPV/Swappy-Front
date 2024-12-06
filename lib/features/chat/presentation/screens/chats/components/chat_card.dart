import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/components/placeholder.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/core/services/chat_service.dart';
import 'package:pin/features/chat/presentation/screens/messages/message_screen.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'profile_image.dart';
import 'chat_details.dart';
import 'package:pin/features/chat/presentation/screens/chats/components/message_status.dart' as msg_status;
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
  String _profileImage = "";
  String? userId;
  int unreadMessagesCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeChatDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (_profileImage.isEmpty || _displayName.isEmpty) {
      return const PlaceholderWidget(); // Loads mock data when user details are not available
    }

    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessagesScreen(chat: widget.chat),
        ));
        await chatService.markChatAsRead(widget.chat.uid, userId!);
        setState(() {
          unreadMessagesCount = 0; // Reset unread count when chat is opened
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding * 0.75,
        ),
        child: Row(
          children: [
            ProfileImage(profileImage: _profileImage),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ChatDetails(displayName: _displayName, latestMessage: latestMessage),
              ),
            ),
            msg_status.MessageStatus(unreadMessagesCount: unreadMessagesCount, latestMessage: latestMessage),
          ],
        ),
      ),
    );
  }

  // ----------------------------------  HELPER METHODS ----------------------------------------------

  Future<void> _initializeChatDetails() async {
    userId = await chatService.getUserId();

    if (userId != null) {
      setState(() {
        _setUserDetails();
      });
    }

    await _fetchChatDetails();
  }

  void _setUserDetails() {
    if (widget.chat.user1 == userId) {
      _displayName = widget.chat.name2;
      _profileImage = widget.chat.image2.isNotEmpty
          ? widget.chat.image2
          : 'assets/images/user.png';
    } else {
      _displayName = widget.chat.name1;
      _profileImage = widget.chat.image1.isNotEmpty
          ? widget.chat.image1
          : 'assets/images/user.png';
    }
  }

  Future<void> _fetchChatDetails() async {
    try {
      final unreadCount = await chatService.getUnreadMessagesCount(widget.chat.uid);
      final latestMessage = await chatService.getLatestMessage(widget.chat.uid);

      setState(() {
        this.latestMessage = latestMessage;
        if (unreadMessagesCount == 0) {
          unreadMessagesCount = unreadCount; // Only update if not already set
        }
      });

    } catch (e) {
      print("Error initializing chat details: $e");
    }
  }
}