import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'package:pin/features/exchanges/models/Product.dart';

class Characteristics extends StatelessWidget {
  const Characteristics({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaciado uniforme
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Talla",
                  style: TextStyle(color: kTextColor),
                ),
                Text(
                  product.size,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Calidad",
                  style: TextStyle(color: kTextColor),
                ),
                Text(
                  product.quality,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Estilos",
                  style: TextStyle(color: kTextColor),
                ),
                Text(
                  product.styles.isEmpty ? "Varios" : product.styles.first,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
