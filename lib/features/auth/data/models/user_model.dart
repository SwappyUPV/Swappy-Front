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
  final int clothes;
  final int followers;
  final int following;
  final int points;
  final int exchanges;
  final String? bio;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePicture,
    this.address,
    this.preferredSizes,
    this.gender,
    this.birthday,
    this.clothes = 0, // Default value for clothes
    this.followers = 0, // Default value for followers
    this.following = 0, // Default value for following
    this.points = 0, // Default value for points
    this.exchanges = 0, // Default value for exchanges
    this.bio,
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
      clothes: json['clothes'] as int? ?? 0, // Default value if null
      followers: json['followers'] as int? ?? 0, // Default value if null
      following: json['following'] as int? ?? 0, // Default value if null
      points: json['points'] is String ? int.tryParse(json['points']) ?? 0 : json['points'] as int? ?? 0, // Handle String to int conversion
      exchanges: json['exchanges'] as int? ?? 0, // Default value if null
      bio: json['bio'] as String?,
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
      'clothes': clothes,
      'followers': followers,
      'following': following,
      'points': points,
      'exchanges': exchanges,
      'bio': bio,
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
      clothes: data['clothes'] as int? ?? 0, // Default value if null
      followers: data['followers'] as int? ?? 0, // Default value if null
      following: data['following'] as int? ?? 0, // Default value if null
      points: data['points'] is String ? int.tryParse(data['points']) ?? 0 : data['points'] as int? ?? 0, // Handle String to int conversion
      exchanges: data['exchanges'] as int? ?? 0, // Default value if null
      bio: data['bio'] as String?,
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
    int? clothes,
    int? followers,
    int? following,
    int? points,
    int? exchanges,
    String? bio,
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
      clothes: clothes ?? this.clothes,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      points: points ?? this.points,
      exchanges: exchanges ?? this.exchanges,
      bio: bio ?? this.bio,
    );
  }

  String? get size => preferredSizes?.join(', ');
  String? get birthDate => birthday?.toDate().toString();
  String? get location => address;
}