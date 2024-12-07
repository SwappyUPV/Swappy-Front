// lib/features/chat/presentation/screens/chats/components/new_chat_popup.dart
import 'package:flutter/material.dart';
import 'package:pin/core/services/chat_service.dart';
import 'package:pin/features/auth/data/models/user_model.dart';

class NewChatPopup extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final VoidCallback onClose;
  final Function(UserModel) onNewChat;

  const NewChatPopup({
    Key? key,
    required this.searchController,
    required this.searchQuery,
    required this.onClose,
    required this.onNewChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Crear nuevo chat mediante nickname",
                fillColor: Colors.grey[300],
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onClose,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: StreamBuilder<List<UserModel>>(
                stream: ChatService().searchUsersByName(searchQuery),
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
                        onTap: () => onNewChat(user),
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