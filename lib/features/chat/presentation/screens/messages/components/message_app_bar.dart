import 'package:flutter/material.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import '../../../../constants.dart';
import 'package:intl/intl.dart';
import 'package:pin/core/constants/constants.dart';

class MessageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? name;
  final String? userId;
  final Chat chat;

  const MessageAppBar({
    super.key,
    required this.name,
    required this.userId,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PrimaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(color: Colors.white),
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name ?? 'Unknown', // Fallback to 'Unknown' if name is null
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'UrbaneMedium',
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.32,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    chat.isActive
                        ? "Activo ahora"
                        : "Hace ${_formatTimestamp(chat.timestamp)}",
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Exchanges(
                    selectedProduct: null,
                    receiverId: chat.user1 == userId ? chat.user2 : chat.user1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutos';
      } else {
        return '${difference.inHours} horas ';
      }
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}