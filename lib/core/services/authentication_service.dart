import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signInWithGoogleSilently() async {
    return await _googleSignIn.signInSilently();
  }

  Future<String> signInWithGoogle() async {
    String res = "Some error occurred";
    try {
      // Start Google Sign-In process
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return "Google sign-in aborted"; // User aborted the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if the user already exists in Firestore
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        // If the user does not exist, add them to Firestore
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
        });
      }

      res = "success";
      print(res);
    } catch (err) {
      print('Error in signInWithGoogle: $err');
      return err.toString();
    }
    return res;
  }

  // SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required Map<String, dynamic> additionalData,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _firestore.collection("users").doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'email': email,
          ...additionalData,
          'birthday': additionalData['birthday'] != null
              ? Timestamp.fromDate(additionalData['birthday'])
              : null,
        });
        res = "success";
      } else {
        res = "Por favor rellena todos los campos";
      }
    } catch (err) {
      print('Error in signupUser: $err');
      return err.toString();
    }
    return res;
  }

  // Log in user
  Future<String> loginUser({required String email, required String password}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      print('Error in loginUser: $err');
      return err.toString();
    }
    return res;
  }

  Future<bool> signOut() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Sign out from Google if the user signed in with Google
        for (var provider in user.providerData) {
          if (provider.providerId == 'google.com') {
            await _googleSignIn.signOut();
            await _googleSignIn.disconnect();
            break;
          }
        }

        // Sign out from Firebase
        await _auth.signOut();
      }

      // Set the logout flag to true in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedOut', true);

      return true;
    } catch (e) {
      print("Error signing out: $e");
      return false;
    }
  }

  // Anonymous Login
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Anonymous sign-in failed: $e');
      return null;
    }
  }

  // Method to get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Save UserModel in SharedPreferences
  Future<void> saveUserModel(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(userId).get();

      if (userDoc.exists) {
        // Convert user document to JSON, handling Timestamp
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Convert any Timestamp fields to DateTime or string
        userData.forEach((key, value) {
          if (value is Timestamp) {
            userData[key] = value.toDate().toString(); // or use value.toDate() for DateTime
          }
        });

        String userModelJson = jsonEncode(userData);
        await prefs.setString('userModel', userModelJson);
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error saving user model: $e');
    }
  }


  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _auth.authStateChanges().first;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedOut', true);
  }
}
