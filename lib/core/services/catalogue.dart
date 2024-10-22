import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getClothes() async {
    try {
      // Obtener la colección de ropa
      QuerySnapshot querySnapshot =
          await _firestore.collection('clothes').get();

      // Convertir los documentos a una lista de mapas
      List<Map<String, dynamic>> clothes = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'nombre': doc['nombre'],
          'precio': doc['precio'],
          'imagen': doc['imagen'],
          'categoria': doc['categoria'],
          'etiquetas': List<String>.from(doc['etiquetas'] ?? []),
        };
      }).toList();

      return clothes;
    } catch (e) {
      print('Error al obtener la ropa: $e');
      return [];
    }
  }

  // Método para obtener una prenda específica por su ID
  Future<Map<String, dynamic>?> getClothById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('clothes').doc(id).get();

      if (doc.exists) {
        return {
          'id': doc.id,
          'nombre': doc['nombre'],
          'precio': doc['precio'],
          'imagen': doc['imagen'],
          'categoria': doc['categoria'],
          'etiquetas': List<String>.from(doc['etiquetas'] ?? []),
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener la prenda: $e');
      return null;
    }
  }
}
