import 'dart:convert';

import 'package:flutter/material.dart';
import 'catalogue_item_card.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/details/details_screen.dart';

class CatalogueGrid extends StatelessWidget {
  final List<Product> filteredCatalogo;
  final Function(Product) toggleFavorite;
  final Set<Product> favoriteProducts;

  const CatalogueGrid({
    super.key,
    required this.filteredCatalogo,
    required this.toggleFavorite,
    required this.favoriteProducts,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // 5 productos por fila en web (ancho > 1024px), 2 en móvil
    final crossAxisCount = width > 1024 ? 5 : 2;
    // Ajustamos el aspect ratio para que las cards se vean bien en ambos layouts
    final childAspectRatio = width > 1024 ? 0.7 : 0.5;

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
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          final item = filteredCatalogo[index];
          return CatalogueItemCard(
            product: item,
            isFavorite: favoriteProducts.toList().contains(item),
            toggleFavorite: () => toggleFavorite(item),
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
