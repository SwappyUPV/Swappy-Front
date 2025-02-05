import 'package:flutter/material.dart';
import 'package:pin/core/services/chat_service_2.dart';
import 'package:pin/features/exchanges/screens/details/details_screen.dart';
import 'package:pin/features/virtual_closet/presentation/screens/virtual_closet_screen.dart';
import 'package:pin/features/virtual_closet/presentation/widgets/change_clothes_app_bar.dart';
import '../../../../core/services/catalogue.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import '/core/services/product.dart';

class ChangeClothes extends StatefulWidget {
  final bool fromExchange;
  final String? id; // ID del usuario para obtener su ropa
  const ChangeClothes({super.key, required this.fromExchange, this.id});

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
    if(widget.fromExchange && widget.id != null) {
      _cachedUserId = widget.id;
      userId = widget.id;
    }
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

  void _cancelSelection() {
    setState(() {
      _selectedProducts.clear();
    });
  }

  Future<void> _deleteSelectedProducts() async {
    // Mostrar diálogo de confirmación
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar ${_selectedProducts.length} prenda(s)?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        for (var product in _selectedProducts) {
          await _productService.deleteProduct(product.id);
        }

        // Limpiar selección y recargar lista
        setState(() {
          _selectedProducts.clear();
        });
        if (_cachedUserId != null) {
          await _fetchClothesForUser(_cachedUserId!);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prendas eliminadas correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar las prendas: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _confirmSelection() {
    Navigator.pop(context, _selectedProducts);
  }

  Future<void> _invertInClosetStatus() async {
    for (var product in _selectedProducts) {
      bool newStatus = !product.inCloset;
      String productId = product.id;
      String result =
          await _productService.updateInClosetStatus(productId, newStatus);
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
            MaterialPageRoute(
                builder: (context) => const VirtualClosetScreen()),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _categorizedClothes.isEmpty
                ? const Center(
                    child: Text(
                      "No has subido ninguna prenda",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _categorizedClothes.entries.map((entry) {
                        final category = entry.key;
                        final products = entry.value;
                        final inClosetCount =
                            products.where((p) => p.inCloset).length;

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
                              height: products.length > 1
                                  ? 300
                                  : 150, // Ajusta la altura según el número de prendas
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: products.length > 1
                                      ? 2
                                      : 1, // 2 filas si hay más de 1 prenda
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 8.0,
                                  childAspectRatio: 1,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final isSelected =
                                      _selectedProducts.contains(product);

                                  return GestureDetector(
                                    onLongPress: () {
                                      if (!widget.fromExchange) {
                                        _toggleProductSelection(product);
                                      }
                                    },
                                    onTap: () async {
                                      if (!widget.fromExchange) {
                                        bool? deleted = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsScreen(
                                              product: product,
                                              showActionButtons: false,
                                              showEditButtons: true,
                                            ),
                                          ),
                                        );

                                        if (deleted == true) {
                                          _fetchClothesForUser(
                                              _cachedUserId!); // Recarga la lista de ropa
                                        }
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
                                          width: isSelected
                                              ? 4
                                              : product.inCloset
                                                  ? 2
                                                  : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
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
            Column(
              children: [
                if (!widget.fromExchange)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _deleteSelectedProducts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Eliminar ${_selectedProducts.length} prenda(s)",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _cancelSelection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.black),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            "Cancelar selección",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.fromExchange
                              ? _confirmSelection
                              : _invertInClosetStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            widget.fromExchange
                                ? "Confirmar y añadir"
                                : "Confirmar selección",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
