import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChatProvider extends InheritedWidget {
  final StreamChatClient client;
  final Channel channel;

  const StreamChatProvider({
    super.key,
    required super.child,
    required this.client,
    required this.channel,
  });

  static StreamChatProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StreamChatProvider>();
  }

  @override
  bool updateShouldNotify(StreamChatProvider oldWidget) {
    return oldWidget.client != client || oldWidget.channel != channel;
  }
}
