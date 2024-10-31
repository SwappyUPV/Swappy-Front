import 'package:flutter/material.dart';
import 'package:pin/core/services/product.dart';

class StylesSelectorWidget extends StatelessWidget {
  final List<String> selectedStyles;
  final List<String> predefinedStyles;
  final Function(List<String>) onStylesChanged;
  final ProductService productService;

  const StylesSelectorWidget({
    super.key,
    required this.selectedStyles,
    required this.predefinedStyles,
    required this.onStylesChanged,
    required this.productService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Estilos:', style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          spacing: 8.0,
          children: [
            ...predefinedStyles.map((style) => FilterChip(
                  label: Text(style),
                  selected: selectedStyles.contains(style),
                  onSelected: (selected) {
                    final newStyles = List<String>.from(selectedStyles);
                    if (selected) {
                      newStyles.add(style);
                    } else {
                      newStyles.remove(style);
                    }
                    onStylesChanged(newStyles);
                  },
                )),
          ],
        ),
      ],
    );
  }
}
