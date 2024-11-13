import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
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
        'userId': currentUser.uid,
        'soloIntercambio': isExchangeOnly,
      });

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
