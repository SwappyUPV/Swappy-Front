import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/core/services/chat_service_2.dart';
import 'components/body.dart';
import 'components/message_app_bar.dart';

class MessagesScreen extends StatefulWidget {
  final Chat chat;

  const MessagesScreen({super.key, required this.chat});

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  final ChatService2 _chatService = ChatService2();
  String? _userId;
  String? _name;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    _userId = await _chatService.getUserId();
    _assignUserDetails(); // Call the method to assign avatar and name
    setState(() {
      _isLoading = false; // Set loading to false after fetching user details
    });
  }

  void _assignUserDetails() {
    if (_userId == widget.chat.user1) {
      _name = widget.chat.name2; // Assign name2 if userId matches user1
    } else {
      _name = widget.chat.name1; // Assign name1 otherwise
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MessageAppBar(
        name: _name,
        userId: _userId,
        chat: widget.chat,
      ),
      body: _isLoading // Show loading indicator while fetching user details
          ? Center(child: CircularProgressIndicator())
          : Body(chat: widget.chat, userId: _userId),
      bottomNavigationBar: null,
    );
  }
}