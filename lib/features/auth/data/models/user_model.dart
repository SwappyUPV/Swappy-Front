import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profilePicture;
  final String address;
  final List<String> preferredSizes;
  final String gender;
  final int birthday;

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

  // Factory method to create a UserModel from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      address: json['address'],
      preferredSizes: List<String>.from(json['preferredSizes']),
      gender: json['gender'],
      birthday: json['birthday'],
    );
  }

  // Method to convert a UserModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'address': address,
      'preferredSizes': preferredSizes,
      'gender': gender,
      'birthday': birthday,
    };
  }
}