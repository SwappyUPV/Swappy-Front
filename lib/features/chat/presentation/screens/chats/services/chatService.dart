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

  // Fetch messages for a specific chat ID
  Stream<List<ChatMessageModel>> fetchMessages(String chatId) async* {
    // Fetch the current authenticated user's ID
    final String? currentUserId = await _userService.fetchAuthenticatedUserID();
    if (currentUserId == null) {
      print("No authenticated user found.");
      yield []; // Yield an empty list if no user is authenticated
      return;
    }

    // Start streaming messages from Firestore
    yield* _firestore
        .collection('users')
        .doc(currentUserId)
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
        // Extract message properties
        return ChatMessageModel(
          id: doc.id,
          type: _stringToChatMessageType(data['type']),
          content: data['content'] ?? '',
          isSender: data['isSender'] ?? false, // Ensure this is a boolean
          status: _stringToMessageStatus(data['status']),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  //TODO The chat and message should also be added in the other user collection. Now it is only in s@gmail.com chats
  // Send a message to a specific chat
  Future<void> sendMessage(String chatId, String messageText, String senderId) async {
    // Fetch the current authenticated user's ID
    final String? currentUserId = await _userService.fetchAuthenticatedUserID();

    // Check if the user is authenticated
    if (currentUserId == null) {
      print("User is not authenticated. Cannot send message.");
      return; // Exit if no authenticated user
    }

    // Prepare the message data
    final messageData = {
      'content': messageText,
      'isSender': true, // Assuming the sender is the current user
      'type': "text",
      'status': "viewed", // Default status
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Debugging: Log the message data before sending
    print("Sending message: $messageData to chat: $chatId");

    // Add the message to the Firestore collection
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chats') // Ensure you are adding it under the correct collection
          .doc(chatId) // Use chatId directly, as it should refer to the chat document
          .collection('messages')
          .add(messageData);
      print("Message sent successfully.");
    } catch (e) {
      print("Error sending message: $e"); // Log any errors that occur
    }
  }


  Future<Chat?> getChatById(String chatId) async {
    final userId = await UserService().fetchAuthenticatedUserID();
    if (userId == null) return null;

    // Fetch the chat document
    final chatDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .get();

    if (chatDoc.exists) {
      // Get the chat data
      final chatData = chatDoc.data()!;

      // Fetch the user document associated with this chat
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Assuming userId is stored in the chat document
          .get();

      // Create a Chat object
      return Chat(
        uid: chatDoc.id,
        name: chatData['name'],
        image: userDoc['profilePicture'] ?? 'assets/images/user.png', // Default image if not found
        user:  chatData['user'],
        timestamp: (chatData['timestamp'] as Timestamp).toDate(), // Make sure timestamp is fetched correctly
        isActive: chatData['isActive'] ?? false,
        isRecent: chatData['isRecent'] ?? true, // You may need to fetch this from the chatData
      );
    }
    return null; // Return null if no chat is found
  }

  Future<ChatMessageModel?> getLatestMessage(String chatId) async {
    final userId = await UserService().fetchAuthenticatedUserID();
    if (userId == null) return null;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      // Log the snapshot for debugging
      print("Latest message snapshot: ${snapshot.docs}");

      if (snapshot.docs.isNotEmpty) {
        final latestMessageDoc = snapshot.docs.first;
        final data = latestMessageDoc.data() as Map<String, dynamic>;

        // Debug logs
        print("Latest message data: $data");

        // Convert the string to the ChatMessageType enum
        ChatMessageType messageType = _stringToChatMessageType(data['type']);

        // Convert the string to the MessageStatus enum
        MessageStatus messageStatus = _stringToMessageStatus(data['status']);

        return ChatMessageModel(
          id: latestMessageDoc.id,
          type: messageType,
          content: data['content'] ?? '',
          isSender: false, // Correctly determine if the message is from the user
          status: messageStatus, // Use the mapped MessageStatus
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      } else {
        print("No messages found for chatId: $chatId");
      }
    } catch (e) {
      print("Error fetching latest message: $e");
    }
    return null; // Return null if no message is found
  }

// Helper function to convert String to MessageStatus
  MessageStatus _stringToMessageStatus(String status) {
    switch (status) {
      case 'notSent':
        return MessageStatus.notSent;
      case 'notViewed':
        return MessageStatus.notViewed;
      case 'viewed':
        return MessageStatus.viewed;
    // Handle other statuses if necessary
      default:
        throw Exception('Unknown message status: $status');
    }
  }


// Helper function to convert String to ChatMessageType
  ChatMessageType _stringToChatMessageType(String type) {
    switch (type) {
      case 'text':
        return ChatMessageType.text;
      case 'image':
        return ChatMessageType.image;
      case 'video':
        return ChatMessageType.video;
    // Handle other types if necessary
      default:
        throw Exception('Unknown message type: $type');
    }
  }


}
