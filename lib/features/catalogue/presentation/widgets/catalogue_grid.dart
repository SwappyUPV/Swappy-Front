import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';
import 'product_detail_modal.dart'; // Importa el nuevo widget

class CatalogueGrid extends StatelessWidget {
  final List<Map<String, dynamic>> filteredCatalogo;

  const CatalogueGrid({Key? key, required this.filteredCatalogo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = Responsive.isMobile(context);
        final int crossAxisCount = isMobile ? 2 : 5;
        final double itemWidth = constraints.maxWidth / crossAxisCount;
        final double aspectRatio =
            isMobile ? 1.0 : (itemWidth / (itemWidth * 1.5));

        return GridView.builder(
          padding: EdgeInsets.all(isMobile ? 4.0 : 8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: isMobile ? 4 : 8,
            mainAxisSpacing: isMobile ? 4 : 8,
          ),
          itemCount: filteredCatalogo.length,
          itemBuilder: (context, index) {
            final item = filteredCatalogo[index];
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => ProductDetailModal(product: item),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          item['imagen'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 4.0 : 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nombre'],
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          ElevatedButton(
                            onPressed: () {
                              // Lógica para iniciar intercambio
                            },
                            child: Text('SWAP'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              minimumSize: Size(double.infinity, 36),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
