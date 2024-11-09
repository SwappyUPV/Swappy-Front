enum ChatMessageType { text, image, audio, video, exchangeNotification }

enum MessageStatus { notSent, sent, notViewed, viewed, failed }

class ChatMessageModel {
  final String id; // Identificador único del mensaje
  final ChatMessageType type; // Tipo de mensaje (texto, imagen, etc.)
  final dynamic content; // Contenido del mensaje (texto, URL de imagen, etc.)
  final String sender; // ID del usuario que envió el mensaje
  final String?
      receiver; // ID del receptor (opcional, en caso de que sea necesario)
  final MessageStatus status; // Estado del mensaje
  final DateTime timestamp; // Fecha y hora en que se envió el mensaje
  final DateTime?
      updatedTimestamp; // (Opcional) Fecha y hora de la última actualización del mensaje

  ChatMessageModel({
    required this.id,
    required this.type,
    required this.content,
    required this.sender,
    this.receiver,
    required this.status,
    required this.timestamp,
    this.updatedTimestamp,
  });
}
