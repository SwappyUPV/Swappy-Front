import 'dart:convert';

import 'package:flutter/material.dart';
import 'catalogue_item_card.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/details/details_screen.dart';

class CatalogueGrid extends StatelessWidget {
  final List<Product> filteredCatalogo;
  final Function(Product) toggleFavorite; // Función para manejar favoritos
  final Set<Product> favoriteProducts; // Lista de productos favoritos

  const CatalogueGrid({
    super.key,
    required this.filteredCatalogo,
    required this.toggleFavorite, // Parámetro de la función toggleFavorite
    required this.favoriteProducts, // Parámetro de la lista de favoritos
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = 2; // 2 productos por fila

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: filteredCatalogo.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.5, // Aumentar la altura de los productos
        ),
        itemBuilder: (context, index) {
          final item = filteredCatalogo[index];
          return CatalogueItemCard(
            product: item,
            isFavorite: favoriteProducts
                .toList()
                .contains(item), // Determina si el producto es favorito
            toggleFavorite: () =>
                toggleFavorite(item), // Llama a la función toggleFavorite
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    product: item,
                    showActionButtons: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
