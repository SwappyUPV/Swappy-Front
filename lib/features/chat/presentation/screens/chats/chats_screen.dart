import 'package:flutter/material.dart';
import 'package:pin/core/services/chat_service_2.dart';
import '../../../../auth/data/models/user_model.dart';
import '../../../../CustomAppBar.dart';
import 'components/body.dart';
import 'components/new_chat_PopUp.dart';

// todo: use of constants and components: code refactoring and clean up
// todo: Add message sent time: Day grouping for message collection. Cache messages by day and scroll to fetch previous days from firebase into cached.

// todo: removal of BottomNavBar in nested message class (complex to implement since the current routing isn't detecting the screens in)
// todo: Make camera functional

//todo: allow google sign in to work with chats

class ChatsScreen extends StatefulWidget {
  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showNewChatPopup = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'MENSAJES',
        iconPath: 'assets/icons/new_chat.svg',
        onIconPressed: _toggleNewChatPopup,
        iconPosition: IconPosition.right, // Para icono a la izquierda
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child:
                    Body(searchQuery: _searchQuery, onDeleteChat: _deleteChat),
              ),
              SizedBox(
                height: 85, // Espacio al final de la ventana
              ),
            ],
          ),
          if (_showNewChatPopup)
            NewChatPopup(
              searchController: _searchController,
              searchQuery: _searchQuery,
              onClose: _closeNewChatPopup,
              onNewChat: _handleNewChat,
            ),
        ],
      ),
    );
  }

  //--------------------------------------------- HELPER METHODS --------------------------------------

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _toggleNewChatPopup() {
    setState(() {
      _showNewChatPopup = !_showNewChatPopup;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _closeNewChatPopup() {
    setState(() {
      _showNewChatPopup = false;
      _searchController.clear();
    });
  }

  void _handleNewChat(UserModel user) async {
    final chatExists = await ChatService2().doesChatExist(user.uid);
    if (!chatExists) {
      await ChatService2().startNewChat(user.uid);
      _closeNewChatPopup();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chat ya existe con el usuario ${user.name}")),
      );
    }
  }

  Future<void> _deleteChat(String chatId) async {
    try {
      await ChatService2().deleteChat(chatId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chat eliminado")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error eliminando chat: $e")),
      );
    }
  }
}
