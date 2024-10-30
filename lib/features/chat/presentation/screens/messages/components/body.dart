import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'package:pin/features/chat/presentation/screens/chats/services/chatService.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../../../../constants.dart';
import 'chat_input_field.dart';
import 'message.dart';
import 'dart:async'; // Import this for StreamSubscription

class Body extends StatefulWidget {
  final String chatId;

  const Body({super.key, required this.chatId});

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  final ChatService _chatService = ChatService();
  final List<ChatMessageModel> _cachedMessages = [];
  bool _isSendingMessage = false;
  String? _userId; // Initialize userId
  late StreamSubscription<List<ChatMessageModel>> _subscription;

  @override
  void initState() {
    super.initState();
    _fetchUserId(); // Fetch the user ID when initializing
    _listenToMessages();
  }

  // Method to fetch user ID from SharedPreferences
  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId'); // Retrieve userId from SharedPreferences
    });
  }

  void _listenToMessages() {
    _subscription = _chatService.fetchMessages(widget.chatId).listen((messages) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        _cachedMessages.clear();
        _cachedMessages.addAll(messages.reversed);
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel the subscription to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: _cachedMessages.isEmpty
                ? const Center(child: Text("No messages yet"))
                : ListView.builder(
              reverse: true, // Start with newest at the bottom
              itemCount: _cachedMessages.length,
              itemBuilder: (context, index) {
                final message = _cachedMessages[index];
                return Message(message: message);
              },
            ),
          ),
        ),
        ChatInputField(
          onMessageSent: (String messageText) async {
            setState(() {
              _isSendingMessage = true;
            });

            await _handleSendMessage(messageText);

            setState(() {
              _isSendingMessage = false;
            });
          },
        ),
      ],
    );
  }

  Future<void> _handleSendMessage(String messageText) async {
    // Check if message is not empty and userId is not null
    if (messageText.isNotEmpty && _userId != null) {
      await _chatService.sendMessage(widget.chatId, messageText, _userId!);
    } else {
      // Optionally show a message to the user that they need to log in or type a message
      print("Message not sent: messageText is empty or userId is null.");
    }
  }
}
