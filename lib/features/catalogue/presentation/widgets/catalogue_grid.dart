import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';

class CatalogueGrid extends StatelessWidget {
  final List<Map<String, dynamic>> filteredCatalogo;

  const CatalogueGrid({Key? key, required this.filteredCatalogo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Usar la propiedad isMobile de la clase Responsive
        final bool isMobile = Responsive.isMobile(context);

        // Calcular el número de columnas y las dimensiones de los elementos
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
            return Card(
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
                        Text(
                          '${item['precio']}€',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
