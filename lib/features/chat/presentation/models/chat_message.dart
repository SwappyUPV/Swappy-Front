import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatMessageType { text, image, audio, video }
enum MessageStatus { notSent, notViewed, viewed }

extension ChatMessageTypeExtension on ChatMessageType {
  String get value {
    switch (this) {
      case ChatMessageType.text:
        return 'text';
      case ChatMessageType.image:
        return 'image';
      case ChatMessageType.audio:
        return 'audio';
      case ChatMessageType.video:
        return 'video';
    }
  }
}

extension MessageStatusExtension on MessageStatus {
  String get value {
    switch (this) {
      case MessageStatus.notSent:
        return 'notSent';
      case MessageStatus.notViewed:
        return 'notViewed';
      case MessageStatus.viewed:
        return 'viewed';
    }
  }
}

class ChatMessage {
  final ChatMessageType messageType;
  final String messageContent; // For text, image, or audio
  final bool isSender; // If the message was sent by the user
  final MessageStatus messageStatus;

  ChatMessage({
    required this.messageType,
    required this.messageContent,
    required this.isSender,
    required this.messageStatus,
  });

  // Factory method to create a ChatMessage from a Map
  factory ChatMessage.fromMap(Map<String, dynamic> data) {
    return ChatMessage(
      messageType: ChatMessageType.values.firstWhere((e) => e.value == data['type'], orElse: () => ChatMessageType.text), // Default to text
      messageContent: data['content'] ?? '',
      isSender: data['isSender'] ?? false,
      messageStatus: MessageStatus.values.firstWhere((e) => e.value == data['status'], orElse: () => MessageStatus.notSent), // Default to notSent
    );
  }

  // Method to convert ChatMessage to a Map for sending to Firestore
  Map<String, dynamic> toMap() {
    return {
      'type': messageType.value, // Use the string value of the enum
      'content': messageContent,
      'isSender': isSender,
      'status': messageStatus.value, // Use the string value of the enum
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
