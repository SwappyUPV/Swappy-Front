import 'package:flutter/material.dart';

class CategoryDropdownWidget extends StatelessWidget {
  final String? selectedCategory;
  final List<String> categories;
  final Function(String) onCategorySelected;

  const CategoryDropdownWidget({
    Key? key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Categoría*',
        border: OutlineInputBorder(),
      ),
      value: selectedCategory?.isNotEmpty == true ? selectedCategory : null,
      items: categories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category));
      }).toList(),
      onChanged: (value) => onCategorySelected(value!),
      validator: (value) =>
          value == null ? 'Por favor, seleccione una categoría' : null,
    );
  }
}
