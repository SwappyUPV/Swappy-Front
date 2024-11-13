import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String uid;
  final String user1;
  final String user2;
  final String name1;
  final String name2;
  final String image1;
  final String image2;
  final DateTime timestamp;
  final bool isActive;
  final bool isRecent;
  final List<String> users;

  Chat({
    required this.uid,
    required this.image1,
    required this.image2,
    required this.user1,
    required this.user2,
    required this.name1,
    required this.name2,
    required this.timestamp,
    required this.isActive,
    required this.isRecent,
    required this.users,
  });

  // Create a factory method for converting Firebase documents into Chat objects
  factory Chat.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      uid: doc.id,
      name1: data['name1'] ?? 'Unknown',
      name2: data['name2'] ?? 'Unknown',
      image1: data['image1'] ?? 'assets/images/user.png', // Default image path
      image2: data['image2'] ?? 'assets/images/user.png', // Default image path
      user1: data['user1'] ?? 'Unknown',
      user2: data['user2'] ?? 'Unknown',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? false,
      isRecent: data['isRecent'] ?? true,
      users: List<String>.from(data['users'] ?? []), // Ensure it's a List<String>
    );
  }
}