import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UploadProductMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPrenda({
    required String name,
    required String description,
    required double price,
    required File image,
    required String category,
  }) async {
    String res = "Ocurrió un error";
    try {
      if (name.isNotEmpty &&
          description.isNotEmpty &&
          price > 0 &&
          image != null) {
        User? user = _auth.currentUser;
        if (user == null) {
          return "Usuario no autenticado";
        }

        // Subir la image al Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = _storage.ref().child('prendas').child(fileName);
        UploadTask uploadTask = ref.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        // Crear un nuevo documento en Firestore
        DocumentReference docRef = await _firestore.collection("prendas").add({
          'name': name,
          'description': description,
          'price': price,
          'image': imageUrl,
          'category': category,
          'userId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        res = "success";
        print("Prenda subida con ID: ${docRef.id}");
      } else {
        res = "Por favor, complete todos los campos";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<List<Map<String, dynamic>>> getPrendasUsuario() async {
    List<Map<String, dynamic>> prendas = [];
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return prendas;
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection("prendas")
          .where('userId', isEqualTo: user.uid)
          .get();

      prendas = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error al obtener las prendas: $e");
    }
    return prendas;
  }
}
