import 'package:flutter/material.dart';
import 'product_detail_modal.dart';
import 'catalogue_item_card.dart';

class CatalogueGrid extends StatelessWidget {
  final List<Map<String, dynamic>> filteredCatalogo;

  const CatalogueGrid({
    super.key,
    required this.filteredCatalogo,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = (width / 120).floor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredCatalogo.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 0,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final item = filteredCatalogo[index];
          return CatalogueItemCard(
            product: item,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailModal(product: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
