import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // FOR EVERY PRODUCT ADDED BY A USER, THE USER WILL RECEIVE POINTS
  // IF THE PRODUCT IS PRIVATE, THE USER WILL RECEIVE 10 POINTS
  // IF THE PRODUCT IS PUBLIC, THE USER WILL RECEIVE 50 POINTS
  // IF THE PRODUCT IS EXCHANGE ONLY, THE USER WILL RECEIVE 60 POINTS
  // The number of clothes will be incremented by 1 for every public product added
  Future<void> updateUserPointsAndClothes(String userId, bool isPublic, bool isExchangeOnly) async {
    //UPDATE THE LOCAL USER MODEL
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userModelJson = prefs.getString('userModel');

    if (userModelJson != null) {
      Map<String, dynamic> userData = jsonDecode(userModelJson);

      int currentPoints = userData['points'] is String ? int.tryParse(userData['points']) ?? 0 : userData['points'] as int;
      int currentClothes = userData['clothes'] as int? ?? 0;

      int pointsToAdd = isPublic
          ? (isExchangeOnly ? 60 : 50)
          : 10;

      int newPoints = currentPoints + pointsToAdd;
      int newClothes = isPublic ? currentClothes + 1 : currentClothes;

      userData['points'] = newPoints;
      userData['clothes'] = newClothes;

      String updatedUserModelJson = jsonEncode(userData);
      await prefs.setString('userModel', updatedUserModelJson);

      // UPDATE FIREBASE USER DOCUMENT
      DocumentReference userDocRef = _firestore.collection('users').doc(userId);
      await userDocRef.update({
        'points': newPoints,
        'clothes': newClothes,
      });
    }
  }


  Future<String> uploadProduct({
    required String title,
    required String description,
    required List<String> styles,
    required String size,
    int? price,
    required String quality,
    required dynamic image,
    required String category,
    required bool isExchangeOnly,
    required bool isPublic,
  }) async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        return "Error: No hay usuario autenticado";
      }

      final storageRef = _storage
          .ref()
          .child('product_images/${DateTime.now().toIso8601String()}.jpg');
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = storageRef.putData(await image.readAsBytes());
      } else if (image is File) {
        uploadTask = storageRef.putFile(image);
      } else {
        throw Exception('Tipo de imagen no soportado');
      }

      await uploadTask.whenComplete(() {});

      final imageUrl = await storageRef.getDownloadURL();

      DocumentReference docRef = await _firestore.collection('clothes').add({
        'nombre': title,
        'descripcion': description,
        'categoria': category,
        'estilos': styles,
        'talla': size,
        'precio': isExchangeOnly ? null : price,
        'calidad': quality,
        'imagen': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userId,
        'soloIntercambio': isExchangeOnly,
        'isPublic': isPublic,
      });

      await updateUserPointsAndClothes(userId, isPublic, isExchangeOnly);

      return "Producto añadido con éxito: ${docRef.id}";
    } catch (e) {
      return "Error al añadir el producto: $e";
    }
  }

  Future<List<String>> getStyles() async {
    QuerySnapshot snapshot = await _firestore.collection('styles').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  Future<List<String>> getSizes(String category) async {
    QuerySnapshot snapshot = await _firestore
        .collection('sizes')
        .where('category', isEqualTo: category)
        .get();

    List<String> sizes =
    snapshot.docs.map((doc) => doc['size'] as String).toList();

    sizes.sort((a, b) {
      int? numA = int.tryParse(a);
      int? numB = int.tryParse(b);
      if (numA != null && numB != null) {
        return numA.compareTo(numB);
      } else {
        List<String> order = ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
        return order.indexOf(a).compareTo(order.indexOf(b));
      }
    });

    return sizes;
  }

  Future<List<String>> getClothingCategories() async {
    QuerySnapshot snapshot =
    await _firestore.collection('clothing_categories').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }
}