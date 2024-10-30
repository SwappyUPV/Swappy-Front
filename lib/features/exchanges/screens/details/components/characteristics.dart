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
                  "${product.size}",
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
                  "Tela",
                  style: TextStyle(color: kTextColor),
                ),
                Text(
                  "Lino",
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
                  "Categoría",
                  style: TextStyle(color: kTextColor),
                ),
                Text(
                  "Vintage",
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
