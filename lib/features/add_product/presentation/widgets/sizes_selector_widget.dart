import 'package:flutter/material.dart';
import 'package:pin/core/services/product.dart';

class SizesSelectorWidget extends StatelessWidget {
  final String selectedSize;
  final List<String> predefinedSizes;
  final Function(String) onSizesChanged;
  final ProductService productService;

  const SizesSelectorWidget({
    super.key,
    required this.selectedSize,
    required this.onSizesChanged,
    required this.productService,
    required this.predefinedSizes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tallas:', style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          spacing: 8.0,
          children: [
            ...predefinedSizes.map((size) => FilterChip(
                  label: Text(size),
                  selected: selectedSize == size,
                  onSelected: (selected) {
                    if (selected) {
                      onSizesChanged(size);
                    }
                  },
                )),
          ],
        ),
      ],
    );
  }
}
