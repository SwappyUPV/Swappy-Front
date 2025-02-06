import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin/features/auth/data/models/user_model.dart';

class UserUpdateService {
  UserModel userModel;

  UserUpdateService(this.userModel);

  Future<void> updateUserField(String field, dynamic value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uid)
        .update({field: value});

    switch (field) {
      case 'name':
        userModel = userModel.copyWith(name: value);
        break;
      case 'size':
        userModel = userModel.copyWith(preferredSizes: [value]);
        break;
      case 'birthday':
        userModel = userModel.copyWith(birthday: value);
        break;
      case 'location':
        userModel = userModel.copyWith(address: value);
        break;
      default:
        break;
    }

    final prefs = await SharedPreferences.getInstance();
    final userModelJson = userModel.toJson();
    if (userModelJson['birthday'] is Timestamp) {
      userModelJson['birthday'] = (userModelJson['birthday'] as Timestamp).toDate().toIso8601String();
    }
    prefs.setString('userModel', jsonEncode(userModelJson));
  }
}