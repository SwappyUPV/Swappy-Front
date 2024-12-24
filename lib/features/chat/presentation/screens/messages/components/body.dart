import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'package:pin/features/chat/presentation/components/exchange_notification.dart';
import 'package:pin/core/services/chat_service_2.dart';
import '../../../../constants.dart';
import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatefulWidget {
  final Chat chat;
  final String? userId; // userId passed as parameter

  const Body({super.key, required this.chat, required this.userId});

  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  final ChatService2 _chatService = ChatService2();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: StreamBuilder<List<ChatMessageModel>>(
              stream: _chatService.fetchMessages(widget.chat.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error cargando mensajes"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Sin mensajes todavía"));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final previousMessage = index > 0 ? messages[index - 1] : null;
                    final showDateDivider = previousMessage == null ||
                        !isSameDay(message.timestamp, previousMessage.timestamp);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDateDivider)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: Text(
                                getFormattedDate(message.timestamp),
                                style: const TextStyle(
                                  color: Color(0xFF939090), // var(--Hora-Fecha-Mensaje, #939090)
                                  fontFamily: "OpenSans",
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  height: 1.0, // line-height equivalent
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        if (message.type == ChatMessageType.exchangeNotification)
                          ExchangeNotification(
                            exchange: message,
                            receiver: widget.chat.user1 == widget.userId
                                ? widget.chat.user2
                                : widget.chat.user1,
                          )
                        else
                          Messages(
                            message: message,
                            userId: widget.userId, // Use widget.userId directly
                            user1: widget.chat.user1,
                            user2: widget.chat.user2,
                            userImage1: widget.chat.image1,
                            userImage2: widget.chat.image2,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
        ChatInputField(
          onMessageSent: (String messageText) async {
            if (messageText.isNotEmpty && widget.userId != null) {
              // Use widget.userId here
              await _chatService.sendMessage(
                  widget.chat.uid, messageText, widget.userId!);
            } else {
              print(
                  "Mensaje no enviado, campo vacío o usuario no loggeado.");
            }
          },
        ),
      ],
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Hoy';
    } else if (difference == 1) {
      return 'Ayer';
    } else if (difference == 2) {
      return 'Anteayer';
    } else if (difference < 7) {
      return 'Hace $difference días';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return 'Hace $weeks semanas';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return 'Hace $months meses';
    } else {
      final years = (difference / 365).floor();
      return 'Hace $years años';
    }
  }
}