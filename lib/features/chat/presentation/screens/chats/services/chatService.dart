import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin/core/services/user_service.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Stream<List<Chat>> fetchActiveChats(bool showActive) async* {
    // Fetch authenticated user ID
    final String? userId = await _userService.fetchAuthenticatedUserID();

    if (userId == null) {
      // If no user is authenticated, return an empty stream
      yield [];
      return;
    }

    // Proceed with fetching chats
    yield* _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .where('isActive', isEqualTo: showActive)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Chat.fromDocument(doc)).toList());
  }
  Stream<List<Chat>> fetchRecentChats(bool showRecent) async* {
    // Fetch authenticated user ID
    final String? userId = await _userService.fetchAuthenticatedUserID();

    if (userId == null) {
      // If no user is authenticated, return an empty stream
      yield [];
      return;
    }

    // Proceed with fetching chats
    yield* _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .where('isRecent', isEqualTo: showRecent)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Chat.fromDocument(doc)).toList());
  }

  // Send a message to a specific chat
  // ChatService.dart
  Future<void> sendMessage(String chatId, String messageText, String senderId) async {
    final messageData = {
      'text': messageText,
      'senderId': senderId,
      'type': ChatMessageType.text.index, // Assuming type is stored as an int
      'status': MessageStatus.notSent.index, // Initial status when sending
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);
  }


  // Fetch messages for a specific chat ID
  Stream<List<ChatMessageModel>> fetchMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ChatMessageModel(
        id: doc.id,
        type: ChatMessageType.values[data['type']], // Assuming type is stored as an int in Firestore
        content: data['text'] ?? '',
        isSender: data['senderId'] == "yourSenderId", // Update this based on your sender ID
        status: MessageStatus.values[data['status']],
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );
    }).toList());
  }

  Future<Chat?> getChatById(String chatId) async {
    final doc = await _firestore.collection('chats').doc(chatId).get();
    if (doc.exists) {
      return Chat.fromDocument(doc);
    }
    return null; // or handle accordingly
  }

}
