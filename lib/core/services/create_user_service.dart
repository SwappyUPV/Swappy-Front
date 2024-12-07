import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CreateUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> createUser({
    required String email,
    required String password,
    required Map<String, dynamic> additionalData,
    required dynamic profileImage,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Create Firebase user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Upload profile image to Firebase Storage
        String profileImageUrl = "";
        if (profileImage != null) {
          if (profileImage is String) {
            // If profileImage is a URL string, use it directly
            profileImageUrl = profileImage;
          } else {
            // Otherwise, upload the file to Firebase Storage
            String fileName = DateTime.now().millisecondsSinceEpoch.toString();
            Reference ref = _storage.ref().child('profile_images').child(fileName);

            if (kIsWeb) {
              UploadTask uploadTask = ref.putData(
                await profileImage.readAsBytes(),
                SettableMetadata(contentType: 'image/png'),
              );
              TaskSnapshot snapshot = await uploadTask;
              profileImageUrl = await snapshot.ref.getDownloadURL();
            } else {
              File file = File(profileImage.path); // profileImage must be a File
              UploadTask uploadTask = ref.putFile(file);
              TaskSnapshot snapshot = await uploadTask;
              profileImageUrl = await snapshot.ref.getDownloadURL();
            }
          }
        }

        // Save user data to Firestore
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'email': email,
          'name': additionalData['name'],
          'address': additionalData['address'],
          'birthday': additionalData['birthday'] != null
              ? Timestamp.fromDate(additionalData['birthday'])
              : null,
          'gender': additionalData['gender'],
          'points': additionalData['points'].toString(), // Store points as string
          'preferredSizes': additionalData['preferredSizes'],
          'profilePicture': profileImageUrl,
        });

        res = "success";
      } else {
        res = "Please fill in all fields";
      }
    } catch (err) {
      print('Error in createUser: $err');
      res = err.toString();
    }
    return res;
  }
}
