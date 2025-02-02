import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/core/services/chat_service_2.dart';
import 'package:pin/features/exchanges/screens/details/details_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';
import 'package:pin/features/virtual_closet/presentation/widgets/change_clothes_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/catalogue.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/CustomAppBar.dart';
import '/core/services/product.dart';

class ChangeClothes extends StatefulWidget {
  final bool fromExchange;

  const ChangeClothes({super.key, required this.fromExchange});

  @override
  _ChangeClothesScreenState createState() => _ChangeClothesScreenState();
}

class _ChangeClothesScreenState extends State<ChangeClothes> {
  final ChatService2 _chatService2 = ChatService2();
  final CatalogService _catalogService = CatalogService();
  final ProductService _productService = ProductService();
  String? _cachedUserId;
  Map<String, List<Product>> _categorizedClothes = {};
  List<Product> _selectedProducts = [];

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
      Map<String, List<Product>> categorizedClothes = {};
      for (var product in clothes) {
        if (categorizedClothes[product.category] == null) {
          categorizedClothes[product.category] = [];
        }
        categorizedClothes[product.category]!.add(product);
      }

      setState(() {
        _categorizedClothes = categorizedClothes;
      });
    } catch (e) {
      print('Error al obtener la ropa del usuario: $e');
    }
  }

  void _toggleProductSelection(Product product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
      } else {
        _selectedProducts.add(product);
      }
    });
  }

  void _confirmSelection() {
    Navigator.pop(context, _selectedProducts);
  }

  Future<void> _invertInClosetStatus() async {
    for (var product in _selectedProducts) {
      bool newStatus = !product.inCloset;
      String productId = product.id;
      String result = await _productService.updateInClosetStatus(productId, newStatus);
      print(result);
    }

    setState(() {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChangeClothesAppBar(
        onIconPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VirtualClosetScreen()),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _categorizedClothes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _categorizedClothes.entries.map((entry) {
                        final category = entry.key;
                        final products = entry.value;
                        final inClosetCount = products.where((p) => p.inCloset).length;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'En clóset: $inClosetCount',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: products.length > 1 ? 300 : 150, // Ajusta la altura según el número de prendas
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: products.length > 1 ? 2 : 1, // 2 filas si hay más de 1 prenda
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 8.0,
                                  childAspectRatio: 1,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final isSelected = _selectedProducts.contains(product);

                                  return GestureDetector(
                                    onLongPress: () {
                                      if (!widget.fromExchange) {
                                        _toggleProductSelection(product);
                                      }
                                    },
                                    onTap: () {
                                      if (!widget.fromExchange) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsScreen(
                                              product: product,
                                              showActionButtons: false,
                                            ),
                                          ),
                                        );
                                      } else {
                                        _toggleProductSelection(product);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.black
                                              : product.inCloset
                                                  ? Colors.black
                                                  : Colors.grey[400]!,
                                          width: isSelected ? 4 : product.inCloset ? 2 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
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
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
          if (_selectedProducts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: widget.fromExchange ? _confirmSelection : _invertInClosetStatus,
                child: Text(widget.fromExchange
                    ? "Confirmar y añadir prendas"
                    : "Confirmar selección de prendas"),
              ),
            ),
        ],
      ),
    );
  }
}