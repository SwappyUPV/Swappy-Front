import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatalogueItemCard extends StatefulWidget {
  final Product product;
  final VoidCallback press;
  final bool isFavorite; // Parámetro para saber si el producto es favorito
  final Function toggleFavorite; // Función para cambiar el estado de favorito

  const CatalogueItemCard({
    super.key,
    required this.product,
    required this.press,
    required this.isFavorite, // Recibimos el estado de favorito
    required this.toggleFavorite, // Recibimos la función para cambiar el estado de favorito
  });

  @override
  _CatalogueItemCardState createState() => _CatalogueItemCardState();
}

class _CatalogueItemCardState extends State<CatalogueItemCard> {
  String? userName; // Para almacenar el nombre del usuario
  bool isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadUserName(widget.product.userId);
    ; // Cargar el nombre del usuario al iniciar el widget
  }

  Future<void> loadUserName(String? userId) async {
    try {
      final user = await getUserById(userId);
      if (user != null) {
        setState(() {
          userName = user.name; // Asigna el nombre del usuario
          isLoading = false; // Detén la carga
        });
      } else {
        setState(() {
          userName = "Usuario desconocido"; // Usuario no encontrado
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error al cargar el usuario: $e");
      setState(() {
        userName = "Error al cargar"; // Muestra un error
        isLoading = false;
      });
    }
  }

  Future<UserModel?> getUserById(String? userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      } else {
        //print("No user found for the given ID: $userId");
        return null;
      }
    } catch (e) {
      print("Error fetching user by ID: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Foto de perfil y nombre de usuario dinámico
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user_2.png'),
                    radius: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isLoading
                          ? "Cargando..." // Mostrar estado de carga
                          : userName ?? "Sin nombre",
                      style: TextStyle(
                        fontFamily: 'UrbaneMedium',
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => widget.toggleFavorite(),
                  ),
                ],
              ),
            ),
            // Resto del contenido (imagen, descripción, etc.)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            // Nombre del producto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.product.title.isNotEmpty
                    ? widget.product.title
                    : 'Camiseta de Verano',
                style: TextStyle(
                  fontFamily: 'UrbaneMedium',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Botón de intercambio
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Exchanges(
                        selectedProduct: widget.product,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 36),
                ),
                child: Text(
                  'SWAP',
                  style: TextStyle(
                    fontFamily: 'UrbaneMedium',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
