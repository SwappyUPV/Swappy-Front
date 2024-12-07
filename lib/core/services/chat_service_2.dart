import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:pin/features/chat/presentation/screens/chats/model/Chat.dart';
import 'package:pin/features/chat/presentation/screens/messages/model/ChatMessageModel.dart';

class ChatService2 {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      print("User ID is null, cannot fetch chats");
      yield [];
      return;
    }
    yield* _database
        .ref()
        .child('chats')
        .onValue
        .map((event) {
      final data = event.snapshot.value;

      if (data == null || data is! Map) {
        return [];
      }
      try {
        final chats = (data).entries.map((entry) {
          final chatData = Map<String, dynamic>.from(entry.value as Map);
          final usersMap = chatData['users'] as Map<dynamic, dynamic>?;
          final users = usersMap != null ? usersMap.keys.map((key) => key.toString()).toList() : <String>[];
          return Chat(
            uid: entry.key,
            name1: chatData['name1'] ?? 'Unknown',
            name2: chatData['name2'] ?? 'Unknown',
            image1: chatData['image1'] ?? 'assets/images/user.png',
            image2: chatData['image2'] ?? 'assets/images/user.png',
            user1: chatData['user1'] ?? 'Unknown',
            user2: chatData['user2'] ?? 'Unknown',
            timestamp: DateTime.fromMillisecondsSinceEpoch(chatData['timestamp']),
            isActive: chatData['isActive'] ?? false,
            isRecent: chatData['isRecent'] ?? true,
            users: users,
            unreadCount: chatData['unreadCount'] != null
                ? Map<String, int>.from(chatData['unreadCount'])
                : {},
          );
        }).where((chat) {
          return chat.users.contains(userId);
        }).toList();

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
      } catch (e, stackTrace) {
        print("Error parsing chats: $e");
        print(stackTrace);
        return [];
      }
    });
  }

  Future<void> deleteChat(String chatId) async {
    try {
      final chatRef = _database.ref().child('chats').child(chatId);
      await chatRef.remove();
    } catch (e) {
      print("Error deleting chat: $e");
      rethrow;
    }
  }

  Stream<ChatMessageModel?> listenForNewMessage(String chatId) async* {
    final String? userId = await getUserId();
    if (userId == null) return;

    yield* _database
        .ref()
        .child('chats')
        .child(chatId)
        .child('messages')
        .orderByChild('timestamp')
        .limitToLast(1)
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        return ChatMessageModel.fromJson(data.values.first as Map<String, dynamic>);
      }
      return null;
    });
  }

  Future<void> sendMessage(String chatId, String messageText, String userId) async {
    if (userId.isEmpty) {
      print("Attempting to send message with empty userId");
      return;
    }

    final messageData = {
      'id': chatId,
      'content': messageText,
      'sender': userId,
      'type': "text",
      'status': "notViewed",
      'timestamp': ServerValue.timestamp,
    };

    try {
      final chatRef = _database.ref().child('chats').child(chatId);
      await chatRef.child('messages').push().set(messageData);

      final chatSnapshot = await chatRef.once();
      if (chatSnapshot.snapshot.value != null) {
        final chatData = chatSnapshot.snapshot.value as Map;
        final users = (chatData['users'] as Map).keys;
        for (String user in users) {
          if (user != userId) {
            final unreadCountRef = chatRef.child('unreadCount').child(user);
            final unreadCountSnapshot = await unreadCountRef.once();
            final currentUnreadCount = unreadCountSnapshot.snapshot.value as int? ?? 0;
            await unreadCountRef.set(currentUnreadCount + 1);
          }
        }
      }

      //print("Message sent successfully.");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> markChatAsRead(String chatId, String userId) async {
    try {
      final chatRef = _database.ref().child('chats').child(chatId);
      await chatRef.child('unreadCount').child(userId).set(0);
      //print("Unread count set to 0 for user: $userId");

      final messageQuery = await chatRef
          .child('messages')
          .orderByChild('timestamp')
          .limitToLast(1)
          .once();

      if (messageQuery.snapshot.value != null) {
        final messages = (messageQuery.snapshot.value as Map).entries;
        for (var entry in messages) {
          final message = entry.value as Map;
          final messageId = entry.key;
          //print("Processing message: $message with ID: $messageId");
          if (message['sender'] != userId && message['status'] == 'notViewed') {
            //print("Updating message status to viewed for message ID: $messageId");
            await chatRef.child('messages').child(messageId).update({'status': 'viewed'});
          }
        }
      } else {
        //print("No messages found for chat ID: $chatId");
      }
    } catch (e) {
      print("Error marking chat as read: $e");
    }
  }


  Future<ChatMessageModel?> getLatestMessage(String chatId) async {
    final String? userId = await getUserId();
    if (userId == null) return null;

    final snapshot = await _database
        .ref()
        .child('chats')
        .child(chatId)
        .child('messages')
        .orderByChild('timestamp')
        .limitToLast(1)
        .once();

    if (snapshot.snapshot.value != null) {
      final data = (snapshot.snapshot.value as Map).values.first;
      return ChatMessageModel.fromJson(data as Map<String, dynamic>);
    }
    return null;
  }

  Stream<ChatMessageModel?> fetchLatestMessage(String chatId) async* {
    yield* _database
        .ref()
        .child('chats')
        .child(chatId)
        .child('messages')
        .orderByChild('timestamp')
        .limitToLast(1)
        .onValue
        .map((event) {
      final data = event.snapshot.value;
      if (data != null) {
        try {
          final messageData = (data as Map<dynamic, dynamic>).values.first;
          return ChatMessageModel.fromJson(Map<String, dynamic>.from(messageData as Map));
        } catch (e) {
          print("Error parsing latest message: $e");
          return null;
        }
      }
      //print("No data found");
      return null;
    });
  }


  Future<Chat?> getChatById(String chatId) async {
    final String? userId = await getUserId();
    if (userId == null) return null;

    final chatSnapshot = await _database.ref().child('chats').child(chatId).once();
    if (chatSnapshot.snapshot.value != null) {
      return Chat.fromJson(chatSnapshot.snapshot.value as Map<String, dynamic>);
    }
    return null;
  }

  Stream<List<ChatMessageModel>> fetchMessages(String chatId) async* {
    yield* _database
        .ref()
        .child('chats')
        .child(chatId)
        .child('messages')
        .orderByChild('timestamp')
        .onValue
        .map((event) {
      final data = event.snapshot.value;
      if (data == null) {
        return [];
      }
      try {
        final messages = (data as Map<dynamic, dynamic>).entries.map((entry) {
          final messageData = Map<String, dynamic>.from(entry.value as Map);
          messageData['id'] = entry.key; // Ensure the id field is assigned
          return ChatMessageModel.fromJson(messageData);
        }).where((message) => message.content.isNotEmpty).toList(); // Filter out empty messages
        return messages;
      } catch (e) {
        print("Error parsing messages: $e");
        return [];
      }
    });
  }

  Future<bool> doesChatExist(String otherUserId) async {
    final String? userId = await getUserId();
    if (userId == null) return false;

    final querySnapshot = await _database
        .ref()
        .child('chats')
        .orderByChild('users/$userId')
        .equalTo(true)
        .once();

    if (querySnapshot.snapshot.value != null) {
      final chats = (querySnapshot.snapshot.value as Map).values;
      return chats.any((chat) {
        final users = (chat['users'] as Map).keys;
        return users.contains(otherUserId);
      });
    }
    return false;
  }

  Stream<List<UserModel>> searchUsersByName(String name) {
    return _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '$name\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> startNewChat(String otherUserId) async {
    final String? currentUserId = await getUserId();
    if (currentUserId == null) return;

    final currentUser = await fetchUserById(currentUserId);
    final otherUser = await fetchUserById(otherUserId);

    if (currentUser == null || otherUser == null) return;

    final chatRef = _database.ref().child('chats').push();
    await chatRef.set({
      'user1': currentUserId,
      'user2': otherUserId,
      'name1': currentUser.name,
      'name2': otherUser.name,
      'image1': currentUser.profilePicture ?? "assets/images/default_user.png",
      'image2': otherUser.profilePicture ?? "assets/images/default_user.png",
      'isActive': false,
      'isRecent': true,
      'timestamp': ServerValue.timestamp,
      'users': {currentUserId: currentUserId, otherUserId: otherUserId},
      'unreadCount': {currentUserId: 0, otherUserId: 0},
    });
  }

  Future<int> getUnreadMessagesCount(String chatId) async {
    try {
      final String? userId = await getUserId();
      if (userId == null) return 0;

      final chatSnapshot = await _database.ref().child('chats').child(chatId).once();
      if (chatSnapshot.snapshot.value != null) {
        final unreadCountMap = (chatSnapshot.snapshot.value as Map)['unreadCount'] as Map?;
        return unreadCountMap != null && unreadCountMap.containsKey(userId)
            ? unreadCountMap[userId] as int
            : 0;
      }
      return 0;
    } catch (e) {
      print("Error fetching unread messages count: $e");
      return 0;
    }
  }

  Future<UserModel?> fetchUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

}