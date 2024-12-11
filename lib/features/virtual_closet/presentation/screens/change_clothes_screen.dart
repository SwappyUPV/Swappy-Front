import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin/core/services/chat_service_2.dart';
import 'package:pin/features/exchanges/screens/details/details_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/catalogue.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/CustomAppBar.dart';

class ChangeClothes extends StatefulWidget {
  final bool
  fromExchange; // Atributo para determinar si se viene de un intercambio

  const ChangeClothes({super.key, required this.fromExchange});

  @override
  _ChangeClothesScreenState createState() => _ChangeClothesScreenState();
}

class _ChangeClothesScreenState extends State<ChangeClothes> {
  final ChatService2 _chatService2 = ChatService2();
  final CatalogService _catalogService = CatalogService();
  String? _cachedUserId;
  Map<String, List<Product>> _categorizedClothes = {};
  List<Product> _selectedProducts = []; // Lista de productos seleccionados

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
    Navigator.pop(
        context, _selectedProducts); // Devuelve los productos seleccionados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'ARMARIO VIRTUAL',
        iconPath: 'assets/icons/back.svg',
        onIconPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VirtualCloset()),
          );

        },
        iconPosition: IconPosition.left,
      ),
      body: Stack(
        children: [
          _categorizedClothes.isEmpty
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
                          final isSelected =
                          _selectedProducts.contains(product);

                          return GestureDetector(
                            onTap: () {
                              if (!widget.fromExchange) {
                                // Navegar a la pantalla de detalles
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
                              width: 120,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Flexible(
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      child: Image.network(
                                        product.image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(product.title,
                                      textAlign: TextAlign.center),
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
          if (widget.fromExchange && _selectedProducts.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _confirmSelection,
                    child: const Text("Confirmar y añadir prendas"),
                  ),
                  const SizedBox(
                      height: 100), // Espacio adicional debajo del botón
                ],
              ),
            ),
        ],
      ),
    );
  }
}
