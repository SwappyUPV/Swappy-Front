import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import '../../widgets/chat_bubble.dart';
import '../../state/chat_controller.dart';

class MessagingPage extends StatefulWidget {
  final types.User user;
  const MessagingPage({super.key, required this.user});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final List<types.Message> _messages = [];
  final ChatController _chatController = ChatController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          messages: _messages,
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: widget.user,
          bubbleBuilder: (child,
              {required message, required nextMessageInGroup}) {
            return buildChatBubble(
              child,
              message: message,
              currentUser: widget.user,
              nextMessageInGroup: nextMessageInGroup,
            );
          },
          dateFormat: DateFormat('hh:mm a'),
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await _chatController.selectFile();
    if (result != null) {
      _addMessage(result);
    }
  }

  void _handleImageSelection() async {
    final result = await _chatController.selectImage();
    if (result != null) {
      _addMessage(result);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    await _chatController.handleFileTap(message, _messages, setState);
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage =
        _chatController.createTextMessage(widget.user, message.text);
    _addMessage(textMessage);
  }
}
