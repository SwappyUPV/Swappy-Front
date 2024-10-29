import 'package:flutter/material.dart';

class ProductDetailModal extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailModal({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    bool soloIntercambio = product['solointercambio'] ?? false;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return Container(
            width: isMobile ? constraints.maxWidth * 0.90 : 500,
            height: isMobile
                ? MediaQuery.of(context).size.height * 0.90
                : MediaQuery.of(context).size.height * 0.75,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                // Sección de imagen y título
                SizedBox(
                  height: isMobile ? 350 : 300,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Center(
                          child: Image.network(
                            product['imagen'] ?? 'URL_imagen_por_defecto',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.7),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          product['nombre'],
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sección de detalles
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Detalles del producto
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Categoría: ${product['categoria']}'),
                                Text('Talla: ${product['tallas']}'),
                              ],
                            ),
                            if (!soloIntercambio)
                              Text(
                                '${product['precio']}€',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Descripción
                        if (product['descripcion'] != null) ...[
                          Text(
                            'Descripción',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(product['descripcion']),
                          const SizedBox(height: 20),
                        ],
                        // Botones de acción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (!soloIntercambio)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Lógica para enviar oferta de compra
                                  },
                                  child: const Text('Ofertar compra'),
                                ),
                              ),
                            if (!soloIntercambio) const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Lógica para enviar oferta de intercambio
                                },
                                child: const Text('Ofertar intercambio'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
