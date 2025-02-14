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
  final Map<String, int> unreadCount; // Unread count for each user

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
    required this.unreadCount,
  });

  factory Chat.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      uid: doc.id,
      name1: data['name1'] ?? 'Unknown',
      name2: data['name2'] ?? 'Unknown',
      image1: data['image1'] ?? 'assets/images/user.png',
      image2: data['image2'] ?? 'assets/images/user.png',
      user1: data['user1'] ?? 'Unknown',
      user2: data['user2'] ?? 'Unknown',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? false,
      isRecent: data['isRecent'] ?? true,
      users: List<String>.from(data['users'] ?? []),
      unreadCount: data['unreadCount'] != null
          ? Map<String, int>.from(data['unreadCount'])
          : {},
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      uid: json['uid'],
      name1: json['name1'] ?? 'Unknown',
      name2: json['name2'] ?? 'Unknown',
      image1: json['image1'] ?? 'assets/images/user.png',
      image2: json['image2'] ?? 'assets/images/user.png',
      user1: json['user1'] ?? 'Unknown',
      user2: json['user2'] ?? 'Unknown',
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      isActive: json['isActive'] ?? false,
      isRecent: json['isRecent'] ?? true,
      users: List<String>.from(json['users'] ?? []),
      unreadCount: json['unreadCount'] != null
          ? Map<String, int>.from(json['unreadCount'])
          : {},
    );
  }
}
