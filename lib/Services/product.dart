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
    required List<String> sizes,
    int? price,
    required String quality,
    required dynamic image,
    required String category,
  }) async {
    try {
      // Obtener el usuario actual directamente de FirebaseAuth
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return "Error: No hay usuario autenticado";
      }

      // Subir imagen a Firebase Storage
      final storageRef = _storage
          .ref()
          .child('product_images/${DateTime.now().toIso8601String()}.jpg');
      UploadTask uploadTask;
      if (kIsWeb) {
        // Para web
        uploadTask = storageRef.putData(await image.readAsBytes());
      } else if (image is File) {
        // Para móvil
        uploadTask = storageRef.putFile(image);
      } else {
        throw Exception('Tipo de imagen no soportado');
      }
      
      // Esperar a que se complete la subida
      await uploadTask.whenComplete(() {});
      
      final imageUrl = await storageRef.getDownloadURL();

      // Crear documento en Firestore
      DocumentReference docRef = await _firestore
          .collection('clothes')
          .add({
        'nombre': title,
        'descripcion': description,
        'categoria': category,
        'estilos': styles,
        'etiquetas': [...styles, ...sizes, quality],
        'tallas': sizes,
        'precio': price,
        'calidad': quality,
        'imagen': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': currentUser.uid,
      });

      return "Producto añadido con éxito: ${docRef.id}";
    } catch (e) {
      return "Error al añadir el producto: $e";
    }
  }

  Future<List<String>> getVerifiedStyles() async {
    QuerySnapshot snapshot = await _firestore
        .collection('styles')
        .where('verified', isEqualTo: true)
        .get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  Future<List<String>> getVerifiedSizes(String category) async {
    QuerySnapshot snapshot = await _firestore
        .collection('sizes')
        .where('category', isEqualTo: category)
        .where('verified', isEqualTo: true)
        .get();
    
    List<String> sizes = snapshot.docs.map((doc) => doc['size'] as String).toList();
    
    sizes.sort((a, b) {
      int? numA = int.tryParse(a);
      int? numB = int.tryParse(b);
      if (numA != null && numB != null) {
        return numA.compareTo(numB);
      } else {
        // Orden personalizado para tallas no numéricas
        List<String> order = ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
        return order.indexOf(a).compareTo(order.indexOf(b));
      }
    });
    
    return sizes;
  }

  Future<void> addNewStyle(String style) async {
    await _firestore.collection('styles').add({
      'name': style,
      'verified': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addNewSize(String size, String category) async {
    await _firestore.collection('sizes').add({
      'size': size,
      'category': category,
      'verified': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<String>> getClothingCategories() async {
    QuerySnapshot snapshot =
        await _firestore.collection('clothing_categories').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }
}
