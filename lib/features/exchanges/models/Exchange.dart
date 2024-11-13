import 'package:cloud_firestore/cloud_firestore.dart';

class Exchange {
  String id;
  String senderId;
  String receiverId;
  List<String> itemsOffered;
  List<String> itemsRequested;
  String status;
  int points;
  DateTime timestamp;
  DateTime lastModified;

  // Constructor
  Exchange({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.itemsOffered,
    required this.itemsRequested,
    required this.status,
    required this.points,
    required this.timestamp,
    required this.lastModified,
  });

  // Método para convertir un documento de Firestore a un objeto Exchange
  factory Exchange.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Exchange(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      itemsOffered: List<String>.from(data['itemsOffered'] ?? []),
      itemsRequested: List<String>.from(data['itemsRequested'] ?? []),
      status: data['status'] ?? 'pendiente',
      points: data['points'] ?? 0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      lastModified: (data['lastModified'] as Timestamp).toDate(),
    );
  }

  // Método para convertir un objeto Exchange a un mapa para almacenarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'itemsOffered': itemsOffered,
      'itemsRequested': itemsRequested,
      'status': status,
      'points': points,
      'timestamp': Timestamp.fromDate(timestamp),
      'lastModified': Timestamp.fromDate(lastModified),
    };
  }
}
