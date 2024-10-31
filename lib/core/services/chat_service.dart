import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Cache the authenticated user's ID to reduce duplicate calls
  String? _cachedUserId;

  Future<String?> getUserId() async {
    if (_cachedUserId == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _cachedUserId = prefs.getString('userId') ?? _auth.currentUser?.uid;

      if (_cachedUserId != null) {
        await prefs.setString('userId', _cachedUserId!);
      }
    }
    return _cachedUserId;
  }

  Stream<List<Chat>> fetchChats({bool? showActive, bool? showRecent}) async* {
    final String? userId = await getUserId();
    if (userId == null) {
      yield [];
      return;
    }

    // Create the base query with `array-contains`
    Query<Map<String, dynamic>> query = _firestore
        .collection('chats')
        .where('users', arrayContains: userId);

    // Apply additional filters if specified
    if (showActive == true) {
      query = query.where('isActive', isEqualTo: showActive);
    }
    if (showRecent == true) {
      query = query.where('isRecent', isEqualTo: showRecent);
    }
    // Fetch the chats
    final querySnapshot = await query.get();

    // Map the documents to Chat objects directly
    final filteredChats = querySnapshot.docs.map((doc) {
      return Chat.fromDocument(doc);
    }).toList();

    // Yield the filtered list of chats
    yield filteredChats;
  }

  // Listen for only the latest incoming message
  Stream<ChatMessageModel?> listenForNewMessage(String chatId) async* {
    final String? userId = await getUserId();
    if (userId == null) return;

    yield* _firestore
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
    if (userId.isEmpty) {
      print("Attempting to send message with empty userId");
      return; // Exit if userId is empty
    }

    final messageData = {
      'id': chatId,
      'content': messageText,
      'sender': userId,
      'type': "text",
      'status': "viewed",
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
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
    final String? userId = await getUserId();
    if (userId == null) return null;

    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty ? _mapToChatMessageModel(snapshot.docs.first) : null;
  }
  Future<Chat?> getChatById(String chatId) async {
    final String? userId = await getUserId();
    if (userId == null) return null;

    // Directly access the specific document instead of using a query
    final chatDoc = await _firestore
        .collection('chats')
        .doc(chatId)
        .get();

    if (chatDoc.exists) {
      final chatData = chatDoc.data()!;

      return Chat(
        uid: chatDoc.id,
        user1: chatData['user1'],
        user2: chatData['user2'],
        image1: chatData['image1'],
        image2: chatData['image2'],
        name1: chatData['name1'],
        name2: chatData['name2'],
        timestamp: (chatData['timestamp'] as Timestamp).toDate(),
        isActive: chatData['isActive'] ?? false,
        isRecent: chatData['isRecent'] ?? true,
        users: chatData['users'].cast<String>(),
      );
    }
    return null;
  }

  Stream<List<ChatMessageModel>> fetchMessages(String chatId) async* {
    final String? userId = await getUserId();
    // Start streaming messages from Firestore
    yield* _firestore
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
          sender: data['sender'] ?? '', //
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
      sender: data['sender'] ?? '',
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
