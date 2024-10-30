import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin/core/services/user_service.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  // Cache the authenticated user's ID to reduce duplicate calls
  String? _cachedUserId;

  Future<String?> _getUserId() async {
    _cachedUserId ??= await _userService.fetchAuthenticatedUserID();
    return _cachedUserId;
  }

  // Fetch chats based on isActive or isRecent flag
  // Update `fetchChats` method with Query type instead of CollectionReference

  Stream<List<Chat>> fetchChats({bool? showActive, bool? showRecent}) async* {
    final String? userId = await _getUserId();
    if (userId == null) {
      yield [];
      return;
    }

    // Initialize the query as a Query type
    Query<Map<String, dynamic>> query = _firestore
        .collection('users')
        .doc(userId)
        .collection('chats');

    // Apply filters conditionally
    if (showActive != null) {
      query = query.where('isActive', isEqualTo: showActive);
    }
    if (showRecent != null) {
      query = query.where('isRecent', isEqualTo: showRecent);
    }

    yield* query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Chat.fromDocument(doc)).toList());
  }


  // Listen for only the latest incoming message
  Stream<ChatMessageModel?> listenForNewMessage(String chatId) async* {
    final String? userId = await _getUserId();
    if (userId == null) return;

    yield* _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) =>
    snapshot.docs.isNotEmpty ? _mapToChatMessageModel(snapshot.docs.first) : null);
  }

  // Optimized method to send a message without fetching user ID each time
  Future<void> sendMessage(String chatId, String messageText, String userId) async {

    final messageData = {
      'content': messageText,
      'isSender': true,
      'type': "text",
      'status': "viewed",
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);
      print("Message sent successfully.");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Fetch the latest message for a specific chat
  Future<ChatMessageModel?> getLatestMessage(String chatId) async {
    final String? userId = await _getUserId();
    if (userId == null) return null;

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty ? _mapToChatMessageModel(snapshot.docs.first) : null;
  }
  Future<Chat?> getChatById(String chatId) async {
    final String? userId = await _getUserId();
    if (userId == null) return null;

    // Directly access the specific document instead of using a query
    final chatDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .get();

    if (chatDoc.exists) {
      final chatData = chatDoc.data()!;
      final userDoc = await _firestore.collection('users').doc(userId).get();

      return Chat(
        uid: chatDoc.id,
        name: chatData['name'] ?? 'Unknown',
        image: userDoc['profilePicture'] ?? 'assets/images/user.png',
        user: chatData['user'],
        timestamp: (chatData['timestamp'] as Timestamp).toDate(),
        isActive: chatData['isActive'] ?? false,
        isRecent: chatData['isRecent'] ?? true,
      );
    }
    return null;
  }

  Stream<List<ChatMessageModel>> fetchMessages(String chatId) async* {
    final String? userId = await _getUserId();
    // Start streaming messages from Firestore
    yield* _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp') // Ensure ascending order to retrieve oldest first
        .snapshots()
        .map((snapshot) {

      // Return an empty list if there are no messages
      if (snapshot.docs.isEmpty) {
        print("No messages found.");
        return [];
      }

      // Map the documents to ChatMessageModel objects
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Handle the possibility of a null timestamp
        Timestamp? timestamp = data['timestamp'] as Timestamp?;
        // Extract message properties
        return ChatMessageModel(
          id: doc.id,
          type: _stringToChatMessageType(data['type']),
          content: data['content'] ?? '',
          isSender: data['isSender'] ?? false, // Ensure this is a boolean
          status: _stringToMessageStatus(data['status']),
          timestamp: timestamp != null ? timestamp.toDate() : DateTime.now(),
        );
      }).toList();
    });
  }

  // Helper to map Firestore document to ChatMessageModel
  ChatMessageModel _mapToChatMessageModel(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      type: _stringToChatMessageType(data['type']),
      content: data['content'] ?? '',
      isSender: data['isSender'] ?? false,
      status: _stringToMessageStatus(data['status']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  MessageStatus _stringToMessageStatus(String status) {
    switch (status) {
      case 'notSent':
        return MessageStatus.notSent;
      case 'notViewed':
        return MessageStatus.notViewed;
      case 'viewed':
        return MessageStatus.viewed;
      default:
        throw Exception('Unknown message status: $status');
    }
  }

  ChatMessageType _stringToChatMessageType(String type) {
    switch (type) {
      case 'text':
        return ChatMessageType.text;
      case 'image':
        return ChatMessageType.image;
      case 'video':
        return ChatMessageType.video;
      default:
        throw Exception('Unknown message type: $type');
    }
  }
}
