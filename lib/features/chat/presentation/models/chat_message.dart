enum ChatMessageType { text, image, audio, video }

enum MessageStatus { notSent, notView, viewed }

class ChatMessage {
  final ChatMessageType messageType;
  final String messageContent; // Para texto, imagen o audio
  final bool isSender; // Si el mensaje fue enviado por el usuario
  final MessageStatus messageStatus;

  ChatMessage({
    required this.messageType,
    required this.messageContent,
    required this.isSender,
    required this.messageStatus,
  });
}
