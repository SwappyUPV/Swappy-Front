import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profilePicture;
  final String address;
  final List<String> preferredSizes;
  final String gender;
  final Timestamp birthday;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePicture,
    required this.address,
    required this.preferredSizes,
    required this.gender,
    required this.birthday,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Print the JSON to see its structure (for debugging)
    debugPrint('UserModel fromJson: $json');

    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePicture: json['profilePicture'] as String?,
      address: json['address'] as String,
      preferredSizes: List<String>.from(json['preferredSizes'] ?? []),
      gender: json['gender'] as String,
      birthday: (json['birthday'] is Timestamp)
          ? json['birthday'] as Timestamp // Already a Timestamp
          : Timestamp.fromMillisecondsSinceEpoch(json['birthday'] is int
          ? json['birthday'] // If it's an int
          : DateTime.parse(json['birthday']).millisecondsSinceEpoch), // Fallback for string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'address': address,
      'preferredSizes': preferredSizes,
      'gender': gender,
      'birthday': birthday.millisecondsSinceEpoch, // Convert Timestamp to int
    };
  }
}
