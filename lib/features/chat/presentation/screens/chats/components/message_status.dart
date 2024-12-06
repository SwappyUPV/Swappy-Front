import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import '../../../../constants.dart';

class MessageStatus extends StatelessWidget {
  final int unreadMessagesCount;
  final ChatMessageModel? latestMessage;

  const MessageStatus({
    Key? key,
    required this.unreadMessagesCount,
    required this.latestMessage,
  }) : super(key: key);

  String _getTimeSinceLastMessage(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months mes${months > 1 ? '' : ''} ';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} d${difference.inDays > 1 ? '' : ''} ';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} h${difference.inHours > 1 ? '' : ''} ';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? '' : ''} ';
    } else {
      return 'Ahora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.64,
            child: Container(
              width: 60,
              height: 13,
              child: Text(
                latestMessage != null
                    ? _getTimeSinceLastMessage(latestMessage!.timestamp)
                    : "",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF707070),
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  height: 1.0, // line-height equivalent
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Add a 10 px vertical distance
          if (unreadMessagesCount > 0)
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Color(0xFF424242), // var(--Mensajes-Pendientes, #424242)
                borderRadius: BorderRadius.circular(45),
              ),
              child: Center(
                child: Text(
                  unreadMessagesCount.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans',
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    height: 1.0, // line-height equivalent
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}