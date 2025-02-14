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
  Future<void> updateUserPointsAndClothes(
      String userId, bool isPublic, bool isExchangeOnly) async {
    //UPDATE THE LOCAL USER MODEL
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userModelJson = prefs.getString('userModel');

    if (userModelJson != null) {
      Map<String, dynamic> userData = jsonDecode(userModelJson);

      int currentPoints = userData['points'] is String
          ? int.tryParse(userData['points']) ?? 0
          : userData['points'] as int;
      int currentClothes = userData['clothes'] as int? ?? 0;

      int pointsToAdd = isPublic ? (isExchangeOnly ? 60 : 50) : 10;

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
    required bool enCloset,
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
        'enCloset': enCloset,
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
    try {
      if (category.toLowerCase() == 'zapatos') {
        // Tallas específicas para zapatos
        return List.generate(13,
            (index) => (33 + index).toString()); // Genera tallas del 33 al 45
      }

      if (category.toLowerCase() == 'accesorios') {
        // Para accesorios, solo retornamos "Talla única"
        return ['Talla única'];
      }

      DocumentSnapshot categoryDoc = await _firestore
          .collection('size_categories')
          .doc(category.toLowerCase())
          .get();

      if (!categoryDoc.exists) {
        return _getDefaultSizes();
      }

      Map<String, dynamic> data = categoryDoc.data() as Map<String, dynamic>;
      List<String> sizes = List<String>.from(data['sizes'] ?? []);

      // Ordenar las tallas según el tipo
      if (sizes.any((size) => size.contains('XXS') || size.contains('XS'))) {
        List<String> order = ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
        sizes.sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));
      }

      return sizes;
    } catch (e) {
      print('Error al obtener tallas: $e');
      return _getDefaultSizes();
    }
  }

  List<String> _getDefaultSizes() {
    return ['S', 'M', 'L', 'XL'];
  }

  Future<List<String>> getClothingCategories() async {
    QuerySnapshot snapshot =
        await _firestore.collection('clothing_categories').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  // Método para actualizar el valor de 'enCloset' de un producto
  Future<String> updateInClosetStatus(String productId, bool inCloset) async {
    try {
      // Obtener la referencia del documento del producto
      DocumentReference productRef =
          _firestore.collection('clothes').doc(productId);

      // Actualizar el campo 'enCloset'
      await productRef.update({
        'enCloset': inCloset,
      });

      return "Estado 'enCloset' actualizado correctamente.";
    } catch (e) {
      return "Error al actualizar el estado 'enCloset': $e";
    }
  }

  Future<String> deleteProduct(String productId) async {
    try {
      await _firestore.collection('clothes').doc(productId).delete();
      return "Producto eliminado exitosamente.";
    } catch (e) {
      return "Error al eliminar el producto: $e";
    }
  }
}
