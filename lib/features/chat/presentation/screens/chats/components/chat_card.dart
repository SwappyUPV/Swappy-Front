import 'package:flutter/material.dart';
import 'package:pin/core/services/chat_service_2.dart';
import 'package:pin/features/chat/presentation/screens/chats/components/placeholder.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/messages/message_screen.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'profile_image.dart';
import 'chat_details.dart';
import 'package:pin/features/chat/presentation/screens/chats/components/message_status.dart'
    as msg_status;
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
  final ChatService2 chatService = ChatService2();
  String _displayName = "";
  String _profileImage = "";
  String? userId;
  int unreadMessagesCount = 0;
  ChatMessageModel? latestMessage;

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

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 90),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFB4B3B3)),
          ),
        ),
        child: InkWell(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MessagesScreen(chat: widget.chat),
              ));
              await chatService.markChatAsRead(widget.chat.uid, userId!);
              if (mounted) {
                setState(() {
                  unreadMessagesCount =
                      0; // Reset unread count when chat is opened
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15), // Padding de 15 a la izquierda
              child: Row(
                children: [
                  ProfileImage(profileImage: _profileImage),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: StreamBuilder<ChatMessageModel?>(
                        stream: chatService.fetchLatestMessage(widget.chat.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          latestMessage = snapshot.data;
                          return ChatDetails(
                            displayName: _displayName,
                            latestMessage: latestMessage,
                            unreadMessagesCount: unreadMessagesCount,
                          );
                        },
                      ),
                    ),
                  ),
                  msg_status.MessageStatus(
                    unreadMessagesCount: unreadMessagesCount,
                    latestMessage: latestMessage,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  // ----------------------------------  HELPER METHODS ----------------------------------------------

  Future<void> _initializeChatDetails() async {
    userId = await chatService.getUserId();

    if (userId != null && mounted) {
      setState(() {
        _setUserDetails();
      });
    }

    await _fetchUnreadMessagesCount();
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

  Future<void> _fetchUnreadMessagesCount() async {
    try {
      final unreadCount =
          await chatService.getUnreadMessagesCount(widget.chat.uid);
      if (mounted) {
        setState(() {
          unreadMessagesCount = unreadCount;
        });
      }
    } catch (e) {
      print("Error fetching unread messages count: $e");
    }
  }
}
