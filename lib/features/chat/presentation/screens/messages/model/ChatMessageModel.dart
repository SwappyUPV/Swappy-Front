enum ChatMessageType { text, image, audio, video }

enum MessageStatus { notSent, notViewed, viewed }

class ChatMessageModel {
  final String id; // Unique identifier for the message
  final ChatMessageType type;
  final String content; // For text, image, or audio
  final bool isSender; // If the message was sent by the user
  final MessageStatus status;
  final DateTime timestamp; // Timestamp of when the message was sent

  ChatMessageModel({
    required this.id,
    required this.type,
    required this.content,
    required this.isSender,
    required this.status,
    required this.timestamp, // Initialize timestamp
  });
}
