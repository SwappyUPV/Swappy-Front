import 'package:flutter/material.dart';

import '../../../constants.dart';

class Description extends StatelessWidget {
  const Description({super.key, required this.product});

  final Map<String, dynamic> product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        product["description"],
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}
