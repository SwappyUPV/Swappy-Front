import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

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
    required File image,
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
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();

      // Crear documento en Firestore
      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('clothes')
          .add({
        'nombre': title,
        'descripcion': description,
        'categoria': styles.isNotEmpty ? styles[0] : 'Sin categoría',
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
    return snapshot.docs.map((doc) => doc['size'] as String).toList();
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
    QuerySnapshot snapshot = await _firestore.collection('clothing_categories').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  Future<void> initializeDefaultStylesAndSizes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool initialized = prefs.getBool('styles_sizes_initialized') ?? false;

    if (!initialized) {
      // Estilos por defecto
      List<String> defaultStyles = [
        'Casual', 'Formal', 'Deportivo', 'Elegante', 'Bohemio', 'Vintage',
        'Minimalista', 'Urbano', 'Clásico', 'Romántico', 'Punk', 'Hippie'
      ];

      // Categorías y tallas por defecto
      Map<String, List<String>> defaultSizes = {
        'Camisetas': ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
        'Pantalones': ['34', '36', '38', '40', '42', '44', '46'],
        'Vestidos': ['XS', 'S', 'M', 'L', 'XL'],
        'Zapatos': ['35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45'],
        'Faldas': ['XS', 'S', 'M', 'L', 'XL'],
        'Chaquetas': ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
        'Accesorios': ['Único']
      };

      // Añadir estilos
      for (String style in defaultStyles) {
        await _firestore.collection('styles').add({
          'name': style,
          'verified': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Añadir categorías y tallas
      for (String category in defaultSizes.keys) {
        await _firestore.collection('clothing_categories').add({
          'name': category,
          'createdAt': FieldValue.serverTimestamp(),
        });

        for (String size in defaultSizes[category]!) {
          await _firestore.collection('sizes').add({
            'size': size,
            'category': category,
            'verified': true,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      // Marcar como inicializado
      await prefs.setBool('styles_sizes_initialized', true);
    }
  }
}
