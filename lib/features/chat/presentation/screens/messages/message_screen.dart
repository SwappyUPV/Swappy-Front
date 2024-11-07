import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/core/services/chat_service.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import '../../../constants.dart';
import 'components/body.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  final Chat chat;

  const MessagesScreen({super.key, required this.chat});

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  final ChatService _chatService = ChatService();
  String? _userId;

  String? _avatar;
  String? _name;

  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    _userId = await _chatService.getUserId();
    print("Initialized User ID: $_userId"); // Debug line
    _assignUserDetails(); // Call the method to assign avatar and name
    setState(() {
      _isLoading = false; // Set loading to false after fetching user details
    });
  }

  void _assignUserDetails() {
    if (_userId == widget.chat.user1) {
      _name = widget.chat.name2; // Assign name2 if userId matches user1
      _avatar = widget.chat.image2; // Assign image2 if userId matches user1
    } else {
      _name = widget.chat.name1; // Assign name1 otherwise
      _avatar = widget.chat.image1; // Assign image1 otherwise
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _isLoading // Show loading indicator while fetching user details
          ? Center(child: CircularProgressIndicator())
          : Body(chat: widget.chat, userId: _userId),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: _avatar != null
                    ? AssetImage(_avatar!)
                    : AssetImage(
                        'assets/images/user.png'), // Fallback to default
              ),
              const SizedBox(width: kDefaultPadding * 0.75),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name ??
                        'Unknown', // Fallback to 'Unknown' if _name is null
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.chat.isActive
                        ? "Active Now"
                        : "Last active ${_formatTimestamp(widget.chat.timestamp)}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.swap_horiz),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Exchanges(
                  selectedProduct: null,
                  userId: widget.chat.user1,
                  chatId: widget.chat.uid,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }
}
