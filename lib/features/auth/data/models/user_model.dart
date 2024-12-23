import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profilePicture;
  final String? address;
  final List<String>? preferredSizes;
  final String? gender;
  final Timestamp? birthday;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePicture,
    this.address,
    this.preferredSizes,
    this.gender,
    this.birthday,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    debugPrint('UserModel fromJson: $json');

    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePicture: json['profilePicture'] as String?,
      address: json['address'] as String?,
      preferredSizes: (json['preferredSizes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      gender: json['gender'] as String?,
      birthday: json['birthday'] is Timestamp
          ? json['birthday'] as Timestamp
          : json['birthday'] is int
          ? Timestamp.fromMillisecondsSinceEpoch(json['birthday'] as int)
          : json['birthday'] is String
          ? Timestamp.fromDate(DateTime.parse(json['birthday'] as String))
          : null,
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
      'birthday': birthday?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] as String,
      email: data['email'] as String,
      profilePicture: data['profilePicture'] as String?,
      address: data['address'] as String?,
      preferredSizes: (data['preferredSizes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      gender: data['gender'] as String?,
      birthday: data['birthday'] as Timestamp?,
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePicture,
    String? address,
    List<String>? preferredSizes,
    String? gender,
    Timestamp? birthday,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      address: address ?? this.address,
      preferredSizes: preferredSizes ?? this.preferredSizes,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
    );
  }

  String? get size => preferredSizes?.join(', ');
  String? get birthDate => birthday?.toDate().toString();
  String? get location => address;

}