import 'package:flutter/material.dart';
import '../../details/details_screen.dart';
import '../../../models/product.dart';
import 'item_card.dart';

class ItemGrid extends StatelessWidget {
  final List<Product> items;

  const ItemGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true, // Hace que el GridView se ajuste a su contenido
        physics:
            NeverScrollableScrollPhysics(), // Desactiva el scroll independiente
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 0,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) => ItemCard(
          product: items[index],
          press: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(
                product: products[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
