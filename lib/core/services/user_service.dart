import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/features/auth/data/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch user information based on user ID (UID)
  Future<UserModel?> fetchUserById(String userId) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data()!);
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null; // Handle error appropriately
    }
  }

  // Fetch the currently authenticated user
  Future<String?> fetchAuthenticatedUserID() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      print("No user is currently authenticated");
      return null;
    }
  }

  // Optionally, fetch all users (if needed)
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return []; // Return an empty list on error
    }
  }
}
