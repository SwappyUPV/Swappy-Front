import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String uid;
  final String name;
  final String lastMessage;
  final String image; // Added image field
  final DateTime timestamp; // Renamed from 'time' to 'timestamp' for clarity with Firestore data
  final bool isActive;
  final bool isRecent;

  Chat({
    required this.uid,
    required this.name,
    required this.lastMessage,
    required this.image,
    required this.timestamp,
    required this.isActive,
    required this.isRecent,
  });

  // Create a factory method for converting Firebase documents into Chat objects
  factory Chat.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      uid: doc.id,
      name: data['name'] ?? 'Unknown',
      lastMessage: data['lastMessage'] ?? '',
      image: data['image'] ?? 'assets/images/user.png', // Default image path
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? false,
      isRecent: data['isRecent'] ?? true,
    );
  }
}
