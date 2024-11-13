/*import 'package:flutter/material.dart';

class VirtualCloset extends StatelessWidget {
  const VirtualCloset({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Armario Virtual'),
      ),
      body: const Center(
        child: Text('Contenido del armario virtual'),
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import '../../../../core/services/catalogue.dart';

class VirtualCloset extends StatefulWidget {
  const VirtualCloset({super.key});

  @override
  _VirtualClosetState createState() => _VirtualClosetState();
}
class _VirtualClosetState extends State<VirtualCloset>{
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  Set<String> _categories = {'Todos'};
  bool _isLoading = true;
  String? UserId = '';

  final CatalogService _catalogService = CatalogService();

  @override
  void initState() {
    super.initState();
    _loadClothes();
  }

  Future<void> _loadClothes() async {
    setState(() {
      _isLoading = true;
    });
    UserId = await _catalogService.getUserId();
    print(UserId);
    print('Hi');
  }

  // Constructor sin const
   //VirtualCloset({super.key});

  final List<String> categories = [
    'Camisetas',
    'Vestidos',
    'Pantalones',
    'Zapatos',
    'Faldas',
    'Chaquetas',
    'Accesorios',
  ];

  final Map<String, List<String>> imagesByCategory = {
    'Camisetas': ['https://firebasestorage.googleapis.com/v0/b/swappy-pin.appspot.com/o/product_images%2F2024-11-11T16%3A25%3A21.321.jpg?alt=media&token=5c39c6e8-010b-4e14-9fb4-e84aac296fa1'],
    'Pantalones': ['https://th.bing.com/th/id/OIP.uIWoHaZ_yZ1uIWQxpracUAHaFJ?rs=1&pid=ImgDetMain'],
    // Añade más URLs para otras categorías si es necesario
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Virtual Closet")),
      body: Column(
        children: [
          // Row para los botones "Todos" y "Colecciones"
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción del botón "Todos"
                    },
                    child: Text("Todos"),
                  ),
                ),
                SizedBox(width: 10), // Separador entre botones
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción del botón "Colecciones"
                    },
                    child: Text("Colecciones"),
                  ),
                ),
              ],
            )
          ),
          // Lista de categorías
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        category,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(
                      height: 100, // Define la altura para la lista de imágenes
                      child: imagesByCategory[category]?.isNotEmpty ?? false
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imagesByCategory[category]?.length ?? 0,
                              itemBuilder: (context, imgIndex) {
                                String imageUrl = imagesByCategory[category]![imgIndex];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Image.network(imageUrl),
                                );
                              },
                            )
                          : Center(
                              child: Text("No hay imágenes disponibles"),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/catalogue.dart';
import 'package:pin/features/exchanges/models/Product.dart';

class VirtualCloset extends StatefulWidget {
  const VirtualCloset({super.key});

  @override
  _VirtualClosetScreenState createState() => _VirtualClosetScreenState();
}

class _VirtualClosetScreenState extends State<VirtualCloset> {
  final CatalogService _catalogue = CatalogService();
  String? _cachedUserId;
  Map<String, List<Product>> _categorizedClothes = {}; // Para almacenar las prendas por categoría

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    String? userId = await _catalogue.getUserId();
    setState(() {
      _cachedUserId = userId;
    });

    if (_cachedUserId != null) {
      _fetchClothesForUser(_cachedUserId!);
    }
  }

  Future<void> _fetchClothesForUser(String userId) async {
    try {
      List<Product> clothes = await _catalogue.getClothByUserId(userId);

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
                                            fit: BoxFit.fill,
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

/*class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(product.image),
            const SizedBox(height: 20),
            Text(product.title, style: const TextStyle(fontSize: 24)),
            Text('Precio: ${product.price} €', style: const TextStyle(fontSize: 16)),
            Text(product.description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}*/

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
                  fit: BoxFit.cover,
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