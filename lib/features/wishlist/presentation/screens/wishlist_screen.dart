import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin/features/exchanges/models/Product.dart';
import 'package:pin/features/catalogue/presentation/widgets/catalogue_grid.dart';
import 'package:pin/features/catalogue/presentation/widgets/navigation_menu.dart';

class WishlistScreen extends StatelessWidget {
  final List<Product> wishlistItems;
  late final NavigationController navigationController;

  WishlistScreen({
    Key? key,
    required this.wishlistItems,
  }) : super(key: key) {
    navigationController = Get.find<NavigationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Deseados',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'UrbaneMedium',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            navigationController.updateIndex(0);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: wishlistItems.isEmpty
          ? const Center(
              child: Text(
                'No hay productos en tu lista de deseados',
                style: TextStyle(
                  fontFamily: 'UrbaneMedium',
                  fontSize: 16,
                ),
              ),
            )
          : CatalogueGrid(filteredCatalogo: wishlistItems),
    );
  }
}
