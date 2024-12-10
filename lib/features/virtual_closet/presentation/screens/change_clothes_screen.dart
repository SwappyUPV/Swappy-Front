import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/core/services/chat_service_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/catalogue.dart';
import 'package:pin/features/exchanges/models/Product.dart';

class ChangeClothes extends StatefulWidget {
  const ChangeClothes({super.key});

  @override
  _VirtualClosetScreenState createState() => _VirtualClosetScreenState();
}

class _VirtualClosetScreenState extends State<ChangeClothes> {
  final ChatService2 _chatService2 = ChatService2();
  final CatalogService _catalogService = CatalogService();
  String? _cachedUserId;
  Map<String, List<Product>> _categorizedClothes = {}; // Para almacenar las prendas por categoría

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    String? userId = await _chatService2.getUserId();
    setState(() {
      _cachedUserId = userId;
    });

    if (_cachedUserId != null) {
      _fetchClothesForUser(_cachedUserId!);
    }
  }

  Future<void> _fetchClothesForUser(String userId) async {
    try {
      List<Product> clothes = await _catalogService.getClothByUserId(userId);

      // Agrupa las prendas por categoría
      Map<String, List<Product>> categorizedClothes = {};
      for (var product in clothes) {
        if (categorizedClothes[product.category] == null) {
          categorizedClothes[product.category] = [];
        }
        categorizedClothes[product.category]!.add(product);
      }

      setState(() {
        _categorizedClothes = categorizedClothes; // Actualiza el estado con las prendas categorizadas
      });
    } catch (e) {
      print('Error al obtener la ropa del usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Armario Virtual")),
      body: _categorizedClothes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _categorizedClothes.entries.map((entry) {
            final category = entry.key;
            final products = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Flexible(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    product.image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(product.title, textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center( // Centra el contenido completo en la pantalla
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
            crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  product.image,
                  width: 500,
                  height: 600,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,  // Centra el texto
              ),
              const SizedBox(height: 8),
              Text(
                'Precio: \$${product.price}',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,  // Centra el precio
              ),
              const SizedBox(height: 16),
              Text(
                product.description,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,  // Centra la descripción
              ),
              // Agrega otros detalles del producto aquí
            ],
          ),
        ),
      ),
    );
  }
}