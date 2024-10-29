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
    final itemSize = (width - (crossAxisCount + 1) * 16) / crossAxisCount;

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
          if (index == filteredCatalogo.length) {
            return GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(Icons.add, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Añadir',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          } else {
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
          }
        },
      ),
    );
  }
}
