import 'package:flutter/material.dart';
import 'package:pin/core/services/chat_service.dart';
import '../../../../auth/data/models/user_model.dart';
import 'components/ChatAppBar.dart';
import 'components/body.dart';

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

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
    final chatExists = await ChatService().doesChatExist(user.uid);
    if (!chatExists) {
      await ChatService().startNewChat(user.uid);
      _closeNewChatPopup();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chat ya existe con el usuario ${user.name}")),
      );
    }
  }

  Future<void> _deleteChat(String chatId) async {
    try {
      await ChatService().deleteChat(chatId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chat eliminado")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error eliminando chat: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        onIconPressed: _toggleNewChatPopup,
      ),
      body: Stack(
        children: [
          Body(searchQuery: _searchQuery, onDeleteChat: _deleteChat),
          if (_showNewChatPopup) buildNewChatPopup(),
        ],
      ),
    );
  }

  /// Builds a popup window to search and start a new chat
  Widget buildNewChatPopup() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Crear nuevo chat mediante nickname",
                fillColor: Colors.grey[300],
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: _closeNewChatPopup,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: StreamBuilder<List<UserModel>>(
                stream: ChatService().searchUsersByName(_searchQuery),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: Text("No hay usuario con ese nickname"));
                  final users = snapshot.data!;

                  return users.isEmpty
                      ? const Center(child: Text("No hay usuario con ese nickname"))
                      : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        onTap: () => _handleNewChat(user),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}