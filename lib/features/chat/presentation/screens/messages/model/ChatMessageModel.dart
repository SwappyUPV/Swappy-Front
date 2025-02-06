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

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    //print("Parsing ChatMessageModel from JSON: $json"); // Log the JSON data

    final id = json['id'];
    final type = ChatMessageType.values.firstWhere((e) =>
    e.toString() == 'ChatMessageType.${json['type']}');
    final content = json['content'];
    final sender = json['sender'];
    final receiver = json['receiver'];
    final status = MessageStatus.values.firstWhere((e) =>
    e.toString() == 'MessageStatus.${json['status']}');
    final timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
    final updatedTimestamp = json['updatedTimestamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['updatedTimestamp'])
        : null;

    //print("Parsed values - id: $id, type: $type, content: $content, sender: $sender, receiver: $receiver, status: $status, timestamp: $timestamp, updatedTimestamp: $updatedTimestamp"); // Log the parsed values

    return ChatMessageModel(
      id: id,
      type: type,
      content: content,
      sender: sender,
      receiver: receiver,
      status: status,
      timestamp: timestamp,
      updatedTimestamp: updatedTimestamp,
    );
  }
}
