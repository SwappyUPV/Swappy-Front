import 'package:pin/core/services/chat_service.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../../constants.dart';

class ChatsScreen extends StatefulWidget {
  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  bool _showNewChatPopup = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {
        _searchQuery = _searchController.text;
      });
    }
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
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Body(searchQuery: _searchQuery),
          if (_showNewChatPopup) buildNewChatPopup(),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              if (mounted) {
                setState(() {
                  _showNewChatPopup = !_showNewChatPopup;
                  _searchController.clear();
                  _searchQuery = '';
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (mounted) {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _searchQuery = '';
                  }
                });
              }
            },
          ),
          if (_isSearching)
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Buscar...",
                  border: InputBorder.none,
                ),
              ),
            ),
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
                hintText: "Search users by name...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        _showNewChatPopup = false;
                        _searchController.clear();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: ChatService().searchUsersByName(_searchQuery),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: Text("No users found"));
                  final users = snapshot.data!;

                  return users.isEmpty
                      ? const Center(child: Text("No users found"))
                      : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        onTap: () async {
                          final chatExists = await ChatService().doesChatExist(user.uid);
                          if (!chatExists) {
                            await ChatService().startNewChat(user.uid);
                            if (mounted) {
                              setState(() {
                                _showNewChatPopup = false;
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Chat already exists with this user")),
                            );
                          }
                        },
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
