import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
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

  Stream<List<Chat>> fetchChats() async* {
    final String? userId = await getUserId();
    if (userId == null) {
      yield [];
      return;
    }

    // Fetch chats where the user is a participant
    yield* _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      final chats = snapshot.docs.map((doc) => Chat.fromDocument(doc)).toList();

      // Sort chats: unread messages first, then by timestamp descending
      chats.sort((a, b) {
        final unreadCountA = a.unreadCount[userId] ?? 0;
        final unreadCountB = b.unreadCount[userId] ?? 0;

        if (unreadCountA > 0 && unreadCountB == 0) {
          return -1;
        } else if (unreadCountA == 0 && unreadCountB > 0) {
          return 1;
        } else {
          return b.timestamp.compareTo(a.timestamp);
        }
      });

      return chats;
    });
  }

  Future<void> deleteChat(String chatId) async {
    try {
      final chatRef = _firestore.collection('chats').doc(chatId);
      final messagesRef = chatRef.collection('messages');

      // Delete all messages in the sub-collection
      final messagesSnapshot = await messagesRef.get();
      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the chat document
      await chatRef.delete();
    } catch (e) {
      print("Error deleting chat: $e");
      throw e;
    }
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
        .map((snapshot) => snapshot.docs.isNotEmpty
            ? _mapToChatMessageModel(snapshot.docs.first)
            : null);
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
      'status': "notViewed",
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      final chatRef = _firestore.collection('chats').doc(chatId);
      await chatRef.collection('messages').add(messageData);

      // Increment unread count for other users
      final chatDoc = await chatRef.get();
      if (chatDoc.exists) {
        List<String> users = List<String>.from(chatDoc['users']);
        for (String user in users) {
          if (user != userId) {
            chatRef.update({
              'unreadCount.$user': FieldValue.increment(1),
            });
          }
        }
      }

      print("Message sent successfully.");
    } catch (e) {
      print("Error sending message: $e");
    }
  }
  Future<void> markChatAsRead(String chatId, String userId) async {
    try {
      final chatRef = _firestore.collection('chats').doc(chatId);

      // Reset unread count for this user
      await chatRef.update({
        'unreadCount.$userId': 0,
      });

      // Optionally, mark all messages as "viewed" for this user
      final messageQuery = await chatRef
          .collection('messages')
          .where('sender', isNotEqualTo: userId)
          .where('status', isEqualTo: 'notViewed')
          .get();

      for (var message in messageQuery.docs) {
        await message.reference.update({'status': 'viewed'});
      }
    } catch (e) {
      print("Error marking chat as read: $e");
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

    return snapshot.docs.isNotEmpty
        ? _mapToChatMessageModel(snapshot.docs.first)
        : null;

  }

  Stream<ChatMessageModel?> fetchLatestMessage(String chatId) async* {
    yield* _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.isNotEmpty
          ? _mapToChatMessageModel(snapshot.docs.first)
          : null;
    });
  }

  Future<Chat?> getChatById(String chatId) async {
    final String? userId = await getUserId();
    if (userId == null) return null;

    // Directly access the specific document instead of using a query
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();

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
        users: chatData['users'].cast<String>(), unreadCount: {},
      );
    }
    return null;
  }

  Stream<List<ChatMessageModel>> fetchMessages(String chatId) async* {
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
        final data = doc.data();
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

  /// Check if a chat already exists between the authenticated user and the specified user ID.
  Future<bool> doesChatExist(String otherUserId) async {
    final String? userId = await getUserId();
    if (userId == null) return false;

    final querySnapshot = await _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .get();

    // Check if any of the chats already include the other user
    return querySnapshot.docs.any((doc) {
      List<String> users = List<String>.from(doc['users']);
      return users.contains(otherUserId);
    });
  }

  /// Fetch users from the `users` collection by name.
  Stream<List<UserModel>> searchUsersByName(String name) {
    return _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '$name\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return UserModel.fromFirestore(doc);
            }).toList());
  }

  Future<void> startNewChat(String otherUserId) async {
    final String? currentUserId = await getUserId();
    if (currentUserId == null) return;

    // Retrieve current user's data
    final currentUser = await fetchUserById(currentUserId);
    final otherUser = await fetchUserById(otherUserId);

    if (currentUser == null || otherUser == null) return;

    // Create a new chat document
    final chatDocRef = await _firestore.collection('chats').add({
      'user1': currentUserId,
      'user2': otherUserId,
      'name1': currentUser.name,
      'name2': otherUser.name,
      'image1': currentUser.profilePicture ?? "assets/images/default_user.png",
      'image2': otherUser.profilePicture ?? "assets/images/default_user.png",
      'isActive': false,
      'isRecent': true,
      'timestamp': FieldValue.serverTimestamp(),
      'users': [currentUserId, otherUserId],
    });

  }


  Future<int> getUnreadMessagesCount(String chatId) async {
    try {
      final String? userId = await getUserId();
      if (userId == null) return 0;

      // Fetch the chat document from Firestore
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();

      if (chatDoc.exists) {
        // Extract the unreadCount map from the chat document
        final Map<String, dynamic>? unreadCountMap = chatDoc.data()?['unreadCount'];

        // Return the unread count for the authenticated user
        return unreadCountMap != null && unreadCountMap.containsKey(userId)
            ? unreadCountMap[userId] as int
            : 0; // Default to 0 if no count is available
      }

      return 0; // Default to 0 if the chat document does not exist
    } catch (e) {
      print("Error fetching unread messages count: $e");
      return 0; // Return 0 in case of errors
    }
  }


  // Fetch a user by their ID
  Future<UserModel?> fetchUserById(String userId) async {
    try {
      // Get the user document from the 'users' collection
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists) {
        // Convert the document data into a UserModel
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
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
      case 'exchangeNotification':
        return ChatMessageType.exchangeNotification;
      default:
        throw Exception('Unknown message type: $type');
    }
  }
}
