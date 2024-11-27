import 'package:flutter/material.dart';
import 'catalogue_item_card.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/exchanges/screens/details/details_screen.dart';

class CatalogueGrid extends StatelessWidget {
  final List<Product> filteredCatalogo;

  const CatalogueGrid({
    super.key,
    required this.filteredCatalogo,
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
