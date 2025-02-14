import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin/features/exchanges/models/Product.dart';

class CatalogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getClothes() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('clothes').get();

      List<Product> clothes = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product(
          id: doc.id,
          title: data['nombre'] ?? '',
          price: data['precio'] ?? 0,
          image: data['imagen'] ?? '',
          description: data['descripcion'] ?? '',
          size: data['talla'] ?? '',
          styles: List<String>.from(data['estilos'] ?? []),
          quality: data['calidad'] ?? '',
          category: data['categoria'] ?? '',
          isExchangeOnly: data['soloIntercambio'] ?? false,
          color: null,
          userId: doc['userId'],
          createdAt: doc['createdAt'] ?? Timestamp.now(),
          isPublic: data['isPublic'] ?? false,
          inCloset: data['enCloset'] ?? false,
        );
      }).toList();

      return clothes;
    } catch (e) {
      print('Error getting clothes: $e');
      return [];
    }
  }

  Future<Set<String>> getCategories() async {
    try {
      // Lista fija de categorías de prendas
      final List<String> clothingCategories = [
        'Accesorios',
        'Camisetas',
        'Pantalones',
        'Zapatos'
      ];

      return Set<String>.from(clothingCategories);
    } catch (e) {
      print('Error getting categories: $e');
      return {};
    }
  }

  Future<Set<String>> getStyles() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('styles').get();
      Set<String> styles = {};

      // Convertir los documentos a una lista y tomar los primeros 5
      final docs = querySnapshot.docs.take(5);

      for (var doc in docs) {
        String name = doc['name'] ?? '';
        if (name.isNotEmpty) {
          styles.add(name);
        }
      }

      return styles;
    } catch (e) {
      print('Error getting styles: $e');
      return {};
    }
  }

  Future<Product?> getClothById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('clothes').doc(id).get();

      if (doc.exists) {
        return Product(
          id: doc.id,
          title: doc['nombre'] ?? '',
          price: doc['precio'] ?? 0,
          image: doc['imagen'] ?? '',
          description: doc['descripcion'] ?? '',
          size: doc['talla'] ?? '',
          styles: List<String>.from(doc['estilos'] ?? []),
          quality: doc['calidad'] ?? '',
          category: doc['categoria'] ?? '',
          isExchangeOnly: doc['soloIntercambio'] ?? false,
          color: null,
          createdAt: doc['createdAt'] ?? Timestamp.now(),
          isPublic: doc['isPublic'] ?? false,
          inCloset: doc['enCloset'] ?? false,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener la prenda: $e');
      return null;
    }
  }

  Future<List<Product>> getClothByUserId(String id) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('clothes')
          .where("userId", isEqualTo: id)
          .get();

      List<Product> clothes = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product(
          id: doc.id,
          title: data['nombre'] ?? '',
          price: data['precio'] ?? 0,
          image: data['imagen'] ?? '',
          description: data['descripcion'] ?? '',
          size: data['talla'] ?? '',
          styles: List<String>.from(data['estilos'] ?? []),
          quality: data['calidad'] ?? '',
          category: data['categoria'] ?? '',
          isExchangeOnly: data['soloIntercambio'] ?? false,
          color: null,
          createdAt: doc['createdAt'] ?? Timestamp.now(),
          isPublic: data['isPublic'] ?? false,
          inCloset: data['enCloset'] ?? false,
        );
      }).toList();

      return clothes;
    } catch (e) {
      print('Error al obtener la ropa: $e');
      rethrow;
    }
  }
}
