import 'package:flutter/material.dart';
import 'package:pin/features/exchanges/screens/home/exchanges.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/core/services/catalogue.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int currentImageIndex = 0;
  Product? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    try {
      // Asumiendo que tienes un servicio para obtener los detalles del producto
      final productData = await CatalogService().getClothById(widget.productId);
      setState(() {
        product = productData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Producto no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product!.title),
      ),
      body: Column(
        children: [
          // Carrusel de imágenes
          Stack(
            children: [
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: product!.image.length,
                  onPageChanged: (index) {
                    setState(() => currentImageIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Image.network(
                      product!.image[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              // Flechas de navegación
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: currentImageIndex > 0
                          ? () => setState(() => currentImageIndex--)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: currentImageIndex < product!.image.length - 1
                          ? () => setState(() => currentImageIndex++)
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Detalles del producto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product!.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  if (product!.price != null)
                    Text(
                      '${product!.price}€',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  const SizedBox(height: 8),
                  Text('Talla: ${product!.size}'),
                  const SizedBox(height: 8),
                  Text('Estilos: ${product!.styles.join(", ")}'),

                  const Spacer(),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Implementar lógica de compra
                          },
                          child: const Text('COMPRAR'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Exchanges(
                                  selectedProduct: product!,
                                ),
                              ),
                            );
                          },
                          child: const Text('SWAP'),
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
  }
}
