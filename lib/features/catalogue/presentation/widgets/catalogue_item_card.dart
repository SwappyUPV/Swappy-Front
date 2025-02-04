import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pin/features/auth/data/models/user_model.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';

import 'dart:async';

class CatalogueItemCard extends StatefulWidget {
  final Product product;
  final VoidCallback press;
  final bool isFavorite;
  final Function toggleFavorite;

  const CatalogueItemCard({
    super.key,
    required this.product,
    required this.press,
    required this.isFavorite,
    required this.toggleFavorite,
  });

  @override
  _CatalogueItemCardState createState() => _CatalogueItemCardState();
}

class _CatalogueItemCardState extends State<CatalogueItemCard> {
  String? userName;
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadUserName(widget.product.userId);
  }

  Future<void> loadUserName(String? userId) async {
    try {
      final user = await getUserById(userId);
      if (mounted) {
        setState(() {
          userName = user?.name ?? "Usuario desconocido";
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userName = "Error al cargar";
          isLoading = false;
        });
      }
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
        return null;
      }
    } catch (e) {
      print("Error fetching user by ID: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                      isLoading ? "Cargando..." : userName ?? "Sin nombre",
                      style: TextStyle(
                        fontFamily: 'UrbaneMedium',
                        fontSize: 13,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.product.image,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.product.title.isNotEmpty
                    ? widget.product.title
                    : 'Nuevo producto!',
                style: TextStyle(
                  fontFamily: 'UrbaneMedium',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                widget.product.size.isNotEmpty
                    ? 'Talla: ${widget.product.size}'
                    : 'Talla no disponible',
                style: TextStyle(
                  fontFamily: 'UrbaneMedium',
                  fontSize: 15,
                ),
              ),
            ),
            // Mostrar Precio o Intercambio
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.isExchangeOnly || widget.product.price == 0
                        ? 'Intercambio'
                        : '\$${widget.product.price}',
                    style: TextStyle(
                      fontFamily: 'UrbaneMedium',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.product.price == 0
                          ? Colors.green
                          : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.isFavorite ? Colors.red : Colors.grey,
                    ),
                    iconSize: 25.0,
                    onPressed: () => widget.toggleFavorite(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
